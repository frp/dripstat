require 'selenium-webdriver'

def set_interval delay
  Thread.new do
    loop do
      sleep delay
      yield
    end
  end
end

class DripStatGame
  SLEEP = 0.01
  SHOPPING_COUNTER = 100
  CAPACITY_COUNTER = 100

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
#    set_interval 1200 do increase_capacity end
#    set_interval 10 do shopping end
#    set_interval 0.01 do clicker end
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

puts ARGV[0]
puts ARGV[1]

game = DripStatGame.new
game.login ARGV[0], ARGV[1]
game.run
sleep 100