class JobController < Formotion::FormController
  def viewDidLoad
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight
    view.autoresizesSubviews = true

    load_data
  end

  def selected_job job
    @job = job
  end

  private
  def load_data
    url = NSUserDefaults.standardUserDefaults.stringForKey("jenkins_url")
    BW::HTTP.get("#{url}/#{@job["name"]}/api/json") do |response|
      @data = BW::JSON.parse(response.body.to_str)

      @form = Formotion::Form.new({
        sections: [{
                     title: "Job Details",
                     rows: [{
                              title: @data["name"],
                              type: :static
                            },
                            {
                              title: @data["description"],
                              type: :static
                            }]
                   }]
      })
    end
  end
end
