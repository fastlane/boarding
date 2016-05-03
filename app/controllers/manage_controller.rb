class ManageController < BaseController
  before_filter :authenticate

  def authenticate
    #export HTTP_AUTH into env as user:password with expected credentials
    if ENV['HTTP_AUTH'] =~ %r{(.+)\:(.+)}
      unless authenticate_with_http_basic { |user, password|  user == $1 && password == $2 }
        request_http_basic_authentication
      end
    end
  end

  def external
  	if user and password
      @testers = app.external_testers
    else
      render 'environment_error'
    end
  end

  def delete
  	tester = find_external(params[:id])
  	
  	if tester && app
  		logger.info "Going to delete the tester: #{tester.email} - #{tester.first_name} #{tester.last_name} from application #{app.name}"

  		begin
  			tester.remove_from_app!(app.apple_id)  			
  			redirect_to "/manage/external", status: 303, :notice => t(:message_success_remove_tester)
  		rescue => ex
  			redirect_to "/manage/external", status: 303, :alert => t(:message_error)  		
  		end
  	end  	
  end

  def renew
  	tester = find_external(params[:id])

  	if tester && app.apple_id.length > 0
  		logger.info "Going to renew the tester: #{tester.email} - #{tester.first_name} #{tester.last_name} from application #{app.name}"

  		begin
  			tester.remove_from_app!(app.apple_id)
				tester.add_to_app!(app.apple_id)
				redirect_to "/manage/external", status: 303, :notice => t(:message_success_renew_tester)
  		rescue => ex
  			redirect_to "/manage/external", status: 303, :alert => t(:message_error)  		
  		end
  	end
  end

  private
  	def find_external(tester_id)
  		 Spaceship::Tunes::Tester::External.find(tester_id)
  	end
end
