class Notifications < ActiveRecord::Base
  attr_accessible :user_id, :type, :form, :to, :unread

  belongs_to :user
  belongs_to :post

  COMMENT = 1
  GROUP = 2
  MENTION = 3

  def self.find_user_mentios(user_id, limit)
    find_by_sql("SELECT notifications. * , COUNT( * )
									FROM notifications
									WHERE notifications.user_id =  '#{user_id}'
									and notifications.note_type = '3'
									and notifications.unread = '0'
									and notifications.unread != '1'
									GROUP BY notifications.from
									ORDER BY notifications.id DESC
									LIMIT #{limit};")

  end

  def self.find_user_mentios_unread(user_id)
    find_by_sql("SELECT notifications. * , COUNT( * )
									FROM notifications
									WHERE notifications.user_id =  '#{user_id}'
									and notifications.note_type = '3'
									and notifications.unread = '1'
									GROUP BY notifications.from
									ORDER BY notifications.id DESC ;")

  end

  def self.find_user_mentios_unread_count(user_id, from)
    find_by_sql("SELECT notifications. * 	FROM notifications
									WHERE (notifications.user_id =  '#{user_id}'
									and notifications.from =  '#{from}')
									and notifications.note_type = '3'
									and notifications.unread = '1'
									GROUP BY notifications.from
									ORDER BY notifications.id DESC ;")

  end
end

