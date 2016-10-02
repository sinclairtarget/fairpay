class GraphsController < GroupAccessController
  include Formatting::Money

  def distribution
    if params[:title].present?
      salaries = @group.salaries.where(title: params[:title])
                                .order(:annual_pay)
    else
      salaries = @group.salaries.order(:annual_pay)
    end

    min = salaries.first.annual_pay.rounddown(1000)
    max = (salaries.last.annual_pay + 1).roundup(1000)
    range = max - min

    bucket_size = range / 10

    buckets = {}
    bucket_min = min
    bucket_max = min + bucket_size
    key = bucket_key(bucket_min, bucket_max)
    buckets[key] ||= 0

    salaries.each do |salary|
      while salary.annual_pay >= bucket_max
        bucket_min += bucket_size
        bucket_max += bucket_size
        key = bucket_key(bucket_min, bucket_max)
        buckets[key] ||= 0
      end

      buckets[key] += 1
    end

    render json: buckets
  end

  def scatter
    if params[:title].present?
      salaries = @group.salaries.where(title: params[:title])
                                .order(:annual_pay)
                                .pluck(:annual_pay)
    else
      salaries = @group.salaries.order(:annual_pay)
                                .pluck(:annual_pay)
    end

    render json: salaries.each_with_index.map { |s, i| [i + 1, s] }
  end

  def title_medians
    data = @group.salaries_by_title.map do |title, grouping|
      [title, grouping.statistics.median_annual_pay]
    end

    data.sort_by! { |tuple| tuple[0] }

    render json: data
  end

  protected
  def bucket_key(bucket_min, bucket_max)
    min_str = dollar(bucket_min, short: true)
    max_str = dollar(bucket_max, short: true)
    "#{min_str} – <#{max_str}"
  end
end
