class RenterRetriever

  def retrieve_renters
    login
    puts "Retrieving renter information for #{reservations.count} reservations"
    total = reservations.count
    count = 0
    reservations.each do |reservation|
      find_renter(reservation)
      count += 1
      puts "Retrieved #{count} of #{total}"
    end
    browser.close
  end

  private

  def login
    browser.goto("https://turo.com/dashboard")
    browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    browser.button(id: 'submit').click
    sleep(3)
  end

  def reservations
    @_reservations ||= Reservation.where(renter: nil)
  end

  def find_renter(reservation)
    browser.goto(reservation.url)
    renter_name = browser.div(class: "text--larger u-bold").inner_html
    renter_photo = browser.img(class: "profilePhoto profilePhoto--medium profilePhoto--round")
    photo_container = renter_photo.parent
    renter_link = photo_container.parent.href
    renter_turo_id = renter_link.split("/").last

    browser.goto(renter_link)
    renter_photo_url = begin
      if browser.h5.inner_html == "Sorry, we can’t find that person."
        nil
      else
        browser.img(class: "profilePhoto--uploader").src
      end
    end

    attrs = {
      name: renter_name,
      remote_photo_url: renter_photo_url
    }

    renter = Renter.find_or_create_by(turo_id: renter_turo_id)
    renter.update(attrs)
    reservation.renter = renter
    reservation.save
  end

  def browser
    @_browser ||= Watir::Browser.new :chrome
  end

end
