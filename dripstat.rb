require 'selenium-webdriver'

class DripStatGame

  def initialize
    @driver = Selenium::WebDriver.for :firefox
  end

  def login username, password
    @driver.get("https://dripstat.com/login.html")
    @driver.find_element(:name, 'username').send_keys username
    @driver.find_element(:name, 'password').send_keys password
    @driver.find_element(:name, 'username').submit
    sleep(5)
    @driver.get("https://dripstat.com/game")
  end

  def run
    counter = 0
    loop do
      counter += 1
      clicker
      shopping
      increase_capacity
    end
  end

  def increase_capacity
    if @driver.find_element(:id, 'localProgressBar').attribute('style') == 'width: 100%;'
      @driver.find_element(:id, 'btn-addGlobalMem').click
      puts "capacity"
    end
  rescue Selenium::WebDriver::Error::ElementNotVisibleError
  end

  def clicker
    element = @driver.find_element(:id, 'btn-addMem')
    @driver.action.click(element).perform
    puts "click"
  end

  def shopping
    puts "shopping"
    children = @driver.find_elements(:class, 'storeItem')
    (children.length - 1).downto(0).each do |x|
      if children[x].attribute('class') == 'storeItem'
        @driver.action.click(children[x]).perform
        break
      end
    end
  rescue Selenium::WebDriver::Error::NoSuchElementError
  end
end

game = DripStatGame.new
game.login ARGV[0], ARGV[1]
game.run
sleep 100