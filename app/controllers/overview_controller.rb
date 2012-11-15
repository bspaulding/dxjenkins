class OverviewController < UIViewController
  def viewDidLoad
    super

    self.title = "Jobs"

    @table = UITableView.alloc.initWithFrame self.view.bounds
    @table.dataSource = self
    @table.delegate = self
    self.view.addSubview @table

    load_data
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuse_identifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuse_identifier) || begin
                                                                               UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuse_identifier)
                                                                             end
    cell.textLabel.text = @data[indexPath.row]["name"]
    cell.imageView.image = UIImage.imageNamed("#{@data[indexPath.row]["color"]}.png")

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    # @job_view = JobController.alloc.init
    # @job_view.selected_job(@data[indexPath.row])

    # self.navigationController.pushViewController(@job_view, animated: true)

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  private

  def load_data
    @data = []

    BW::HTTP.get("#{NSUserDefaults.standardUserDefaults.stringForKey("jenkins_url")}/api/json") do |response|
      response_data = BW::JSON.parse(response.body.to_str)

      @data = response_data["jobs"]

      @table.reloadData
    end
  end
end
