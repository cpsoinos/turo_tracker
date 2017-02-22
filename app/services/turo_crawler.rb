# require 'polipus'
# require 'mongo'
# require 'polipus/plugins/cleaner'
# # Define a Mongo connection
#
# class TuroCrawler
#   # Override some default options
#
#   def execute
#     register_plugins
#     crawl('rubygems')
#   end
#
#   def crawl(doc_name)
#     Polipus.crawler(doc_name, starting_urls, options) do |crawler|
#       # Ignore urls pointing to a gem file
#       crawler.skip_links_like(/\.gem$/)
#       # Ignore urls pointing to an atom feed
#       crawler.skip_links_like(/\.atom$/)
#       # Ignore urls containing /versions/ path
#       crawler.skip_links_like(/\/versions\//)
#
#       # Adding some metadata to a page
#       # The metadata will be stored on mongo
#       crawler.on_before_save do |page|
#         page.user_data.processed = false
#       end
#
#       # In-place page processing
#       crawler.on_page_downloaded do |page|
#         # A nokogiri object
#         puts "Page title: #{page.doc.css('title').text}"
#       end
#
#       # Do a nifty stuff at the end of the crawling session
#       crawler.on_crawl_end do
#         # Gong.bang(:loudly)
#       end
#     end
#   end
#
#   # Crawl the entire rubygems's site
#   # Polipus.crawler('polipus-rubygems', starting_urls, options)
#
#
#
#   private
#
#   # def mongo
#   #   @_mongo ||= Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'crawler')
#   #   # @_mongo ||= Mongo::Connection.new(pool_size: 15, pool_timeout: 5).db('crawler')
#   # end
#
#   def options
#     @_options ||= {
#       # Redis connection
#       redis_options: {
#         host: 'localhost',
#         db: 5,
#         driver: 'hiredis'
#       },
#       # Page storage: pages is the name of the collection where
#       # pages will be stored
#       storage: Polipus::Storage.mongo_store(mongo, 'pages'),
#       # Use your custom user agent
#       user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71',
#       # Use 5 threads
#       workers: 5,
#       # Queue overflow settings:
#       #  * No more than 5000 elements on the Redis queue
#       #  * Exceeded Items will stored on Mongo into 'rubygems_queue_overflow' collection
#       #  * Check cycle is done every 60 sec
#       queue_items_limit: 5_000,
#       queue_overflow_adapter: Polipus::QueueOverflow.mongo_queue(mongo, 'rubygems_queue_overflow'),
#       queue_overflow_manager_check_time: 60,
#       # Logs goes to the stdout
#       logger: Logger.new(STDOUT),
#       http_user: ENV['TURO_USERNAME'],
#       http_password: ENV['TURO_PASSWORD']
#     }
#   end
#
#   def starting_urls
#     @_starting_urls ||= ['http://rubygems.org/gems']
#   end
#
#   def register_plugins
#     Polipus::Plugin.register Polipus::Plugin::Cleaner, reset: true
#   end
#
# end
