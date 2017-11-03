require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { js_errors: false, timeout: 10000 })
end

class Jobcan
  WORKING_STATUS = { "未出勤": :before_work, "勤務中": :on_duty, "退室中": :clock_out }
  RETRY_COUNT = 3

  def initialize(authentication)
    @authentication = authentication
    @retry = RETRY_COUNT
  end

  def clock_in
    visit_and_login

    return false if working_status != :before_work

    # session.find('p#adit-button-push').click

    while working_status == :before_work && @retry > 0
      sleep 1
      @retry -= 1
    end

    if working_status == :on_duty
      true
    else
      false
    end
  rescue => e
    false
  end

  def clock_out
    visit_and_login

    return false if working_status != :on_duty

    # session.find('p#adit-button-work-end').click

    while working_status == :on_duty && @retry > 0
      sleep 1
      @retry -= 1
    end

    if working_status == :clock_out
      true
    else
      false
    end
  rescue => e
    false
  end

  private

  def visit_and_login
    session.visit "https://ssl.jobcan.jp/login/pc-employee/?client_id=#{@authentication.client_name}"

    session.fill_in("email", with: @authentication.user_name)
    session.fill_in("password", with: @authentication.decrypted_password)

    session.click_button('ログイン')
  end

  def session
    @session ||= Capybara::Session.new(:poltergeist)
  end

  def working_status
    status = session.find('#working_status').text&.to_sym
    WORKING_STATUS&.[](status)
  end
end
