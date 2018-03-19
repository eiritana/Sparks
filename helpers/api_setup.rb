module Helpers
    def setup_apis(plugins, config)
        loaded = []
        
        plugins.each do |plugin|
            plugin.constantize.apis.each do |api|
                unless loaded.include? api
                    if api == "twitter" and config["keys"]["twit_consumer_key"] and config["keys"]["twit_consumer_key"]
                        require 'twitter'
                        Main.apis["twitter"] = Twitter::REST::Client.new do |c|
                                c.consumer_key = config["keys"]["twit_consumer_key"]
                                c.consumer_secret = config["keys"]["twit_consumer_secret"]
                        end
                        loaded << api
                    elsif api == "github" and config["keys"]["gh_key"] and config["keys"]["gh_secret"]
                        require 'github_api'
                        Github.configure do |c|
                            c.client_id = config["keys"]["gh_key"]
                            c.client_secret = config["keys"]["gh_secret"]
                        end
                        Main.apis["github"] = Github
                        loaded << api
                    elsif api == "yt" and config["keys"]["yt_key"]
                        require 'yt'
                        Yt.configure do |c|
                            c.api_key = config["keys"]["yt_key"]
                        end
                        Main.apis["yt"] = Yt
                        loaded << api
                    elsif api == "owm" and config["keys"]["owm_key"]
                        Main.apis["owm"] = config["keys"]["owm_key"]
                        loaded << api
                    elsif api == "d2k5" and config["keys"]["d2k5_key"]
                        Main.apis["d2k5"] = config["keys"]["d2k5_key"]
                        loaded << api
                    elsif api == "mekanize"
                        Main.apis["mekanize"] = Mechanize.new
                        loaded << api
                    elsif api == "load_anyway"
                        loaded << api
                    end
                end
            end
        end

        puts "#{Time.now.strftime("[%Y/%m/%d %H:%M:%S.%L]")} \e[33m!!\e[0m [api setup] Loaded APIs: '#{loaded.join(", ")}'"
        return loaded
    end
    
    module_function :setup_apis
end