module ApplicationHelper
  LANDING_URL = "http://paysymmetry.com".freeze
  MIN_GROUP_MEMBERS = 3

  include Formatting::Money
  include Formatting::Titles
  include Anonymity::Fudging

  def group_selected_class(is_selected)
    if is_selected
      "selected"
    else
      ""
    end
  end

  def current_title
    cap(@title || "All Titles")
  end

  def fudged_salary(salary, members)
    return [false, dollar(salary.annual_pay)] if members > MIN_GROUP_MEMBERS

    salt = salary.updated_at.to_i
    min, max = fudge(salary.annual_pay, members, salt)
    [true, dollar(min, short: true) + " – " + dollar(max, short: true)]
  end

  def titles_for_autocomplete(group)
    salaries_by_title = group.salaries_by_title

    titles_string = ""
    salaries_by_title.each do |title, salaries|
      titles_string << "#{title},#{salaries.count};"
    end

    titles_string
  end
  
  def get_data
#    {
#    labels: ["$35k–$45k", "$45k–$55k", "$55k-$65k", "$65k-$75k", "$75k-$85k",
#                "$85k-$95k", "$95k-$105k"],
#    datasets: [
#        {
#            label: "All Salaries",
#            backgroundColor: "rgba(0, 119, 137, 0.15)",
#            borderColor: "rgb(0, 119, 137)",
#            borderWidth: 1,
#            data: [2, 1, 6, 7, 1, 0, 1]
#        }
#    ]
#    }

    {
      "$35k-$45k" => 2,
      "$45k-$55k" => 1,
      "$55k-$65k" => 6,
      "$65k-$75k" => 7,
      "$75k-$85k" => 1,
      "$85k-$95k" => 0,
      "$95k-$105k" => 1,
    }
  end

  def get_library
    {
      scales: {
        xAxes: [{
          scaleLabel: { 
            fontColor: "#666",
            fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
            fontSize: 12,
            fontStyle: "italic"
          }
        }],
        yAxes: [{
          scaleLabel: { 
            fontColor: "#666",
            fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
            fontSize: 12,
            fontStyle: "italic"
          }
        }]
      }
    }
  end
end
