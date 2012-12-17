module PostHelper
  # if the types partial doesn't exist, serve post
  def oz_type_partial(post_type)
    # this is messy
    types_base = 'post/types/'
    if File.exists? "#{Rails.root}/app/views/#{types_base}_#{post_type}.html.erb"
      types_base + post_type
    else
      types_base + 'post'
    end
  end


#################################################################################
###  Videos de youtube
def parse_youtube(url)
    a = url.split('//').last.split('/')
    b = a.last.split('watch?v=').last.split('?').first.split('&').first
    if a[1] == 'p'
        url = "p/#{b}"
    else
        url = b
    end
end
#################################################################################
###  Convertir url grupos y usuarios y links

def text_parse(str)
	p2 = ""
      str.split.each do |t|
        t11 = t.gsub(/\s?(^#)?/, "")
	      p = t.gsub(/^#\w+/) { link_to "##{t11}", "/post/tag/#{t11}", :class => "linkRemote" }

        t21 = t.gsub(/\s?(^@)?/, "")
        p1 = p.gsub(/^@\w+/) { link_to "@#{t21}", "/post/user/#{t21}", :class => "linkRemote" }

        t30 = t.scan(/(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix)
	      p2 << "\n" + p1.gsub(/(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix) {link_to "#{$1[0..39]}...",  "#{$1}", :target => "_blank"}
      end
	return p2
end

######################################################################################
## theme_helper.rb

  # get an array of tag names and generate a comma separated, linked string of tags
  def linked_tags_with_commas(tags)
    tags.dup.map { |tag|
      tag_link(tag.name)
    }.join(', ')
  end

  # RedCloth wrapper -- clean this up if you have redcloth installed for sure
  def r(x)
    begin
      require_gem 'RedCloth'
      RedCloth.new(x).to_html
    rescue
      x
    end
  end
######################################################################################
  # links to months we have posts for with year prepended
  def oz_archived_months(sep = ', ')
    year, string = 0, ''
    months = {}
    years = []

    Post.archived_months.map do |month|
      date = Time.parse(month)
      if date.year > year
        year = date.year
        months[year] = []
        years << year
      end
      months[year] << month_link(date.strftime('%B').downcase, month)
    end

    years.map { |y| "#{y}: " << months[year].join(sep) }.join('<br/>')
  end

  # clean date
  def oz_clean_date(date)
    "%d/%02d/%02d" % [date.year, date.month, date.day]
  end

  # clean date link
  def oz_clean_date_link(date)
    url_for :controller => 'post', :action => 'list_by_date', :year => date.year,
            :month => ("%02d" % date.month), :day => ("%02d" % date.day)
  end

  # return linked post types
  def oz_post_types(sep = ', ')
    TYPES.dup.keys.map { |type| post_type_link(type + 's', type) }.join(sep)
  end

  # the 5 most recent tags
  def oz_recent_tags(sep = ' . ', limit = 5)
    Tag.find(:all, :order => "updated_at DESC", :limit => limit).map { |t| tag_link(t.name) }.join(sep)
  end

  # popular tags (by frequency)
  def oz_popular_tags(sep = ' . ', limit = 5)
    Tag.find_most_popular(limit).map { |t| tag_link(t.name) }.join(sep)
  end

  # display all the tags
  def oz_all_tags(sep = ' ', plus_tag_link = true)
    tags = params[:tag].split(' ') if params[:tag]
    Tag.find(:all, :order => 'name ASC').map { |t| (plus_tag_link ? add_tag_link(t.name) : '') << tag_link(t.name) }.join(sep)
  end

  # the current tag
  def oz_current_tag(default = 'post')
    if @error_msg
      "error"
    elsif params[:tag]
      params[:tag].gsub(' ','+')
    else
      default
    end
  end

  # builds a link to a list of posts for a type
  def post_type_link(text, type = nil)
    type = text if type.nil?
    link_to text, :controller => 'post', :action => 'list_by_type',
                  :type => type
  end

  # builds a link to a month
  def month_link(text, date)
    date = date.respond_to?(:strftime) ? date : Time.parse(date)
    link_to text, :controller => 'post', :action => 'list_by_date',
                  :year => date.strftime('%Y'), :month => date.strftime('%m')
  end

  # if we're looking at a tag, give the option to add (or remove) another tag
  def tag_link(t)
    link_to "##{t}", :controller => 'post', :action => "list", :pagina => "tag", :id => t
  end

  # add a + or - in front of tags if we're looking at a tag's listing
  def add_tag_link(tag)
    cur_tag = params[:tag]
    if cur_tag and !cur_tag.split.select { |x| x =~ /^#{tag}$/ }.empty?
      link = cur_tag.split
      if link.size == 1
        link_to('-', '/', :class => 'remove-tag')
      else
        link = link.reject { |x| x =~ /^#{tag}$/ } * '+'
        link_to('-', {:controller => 'post', :action => 'tag', :tag => link},
                     { :class => 'remove-tag' })
      end
    elsif cur_tag
      link = "#{cur_tag.gsub(' ','+')}+#{tag}"
      # the gsub below is an annoying hack to fight against the uri encoding.
      # need to find a way to turn it off..
      link_to('+', {:controller => 'post', :action => 'tag', :tag => link},
                   { :class => 'add-tag', :rel => 'nofollow' }).gsub(/%2B/,'+')
    else
      ""
    end
  end

  # for feed titles, mostly.  strip out the textile markup.
  def strip_textile(x)
    x = x.gsub(/<.+?>/,'')
    x = x.gsub(/\"(.*?)\":http:\/\/([^ ]*)( )?/,'\1 ') unless x.blank?
    x
  end

  # messy.  sorry.
  def oz_render_theme_partial(partial, options = {})
    render({:partial => ('post/' + partial) }.merge(options))
  end
end

