# Notification types

# 'User channel' notifications types
USER = 1    # Mencion

# 'Tag channel' notifications types
FOLLOW = 2     # New follower
TAG_POST = 3     # New post with this tag

# 'Post channel' notifications types
POST = 4       # New post
COMMENT = 5    # New comment
LIKE = 6       # New like
SHARE = 7      # New share

subs = Subscriptions.all
subs.each do |s|
  channel = ''
  if s.subscription_type == 1
    channel = 'u_'
  elsif s.subscription_type == 2
    channel = 't_'
  elsif s.subscription_type == 3
    channel = 'p_'
  end
  events = []
  s.name = ActiveSupport::Notifications.subscribe ("#{channel}" + "#{s.resource_id}") do |*args|
  events << ActiveSupport::Notifications::Event.new(*args)
    event = events.last
    note = Notifications.new
    note.user_id = Thread.current[:user]
    note.note_type = event.payload[:note_type]
    note.from = event.payload[:from]
    note.resource_id = event.payload[:resource_id]
    note.unread = 1
    note.save
  end
  s.save
end