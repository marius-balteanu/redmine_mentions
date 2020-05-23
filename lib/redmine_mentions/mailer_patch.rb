# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2010-2020 RedmineUP
# http://www.redmineup.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

module RedmineMentions
  module Patches
    module MailerPatch
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end

      module ClassMethods
      end

      module InstanceMethods
        def notify_mentioning(user, issue, journal)
          redmine_headers 'Project' => issue.project.identifier,
                          'Issue-Tracker' => issue.tracker.name,
                          'Issue-Id' => issue.id,
                          'Issue-Author' => issue.author.login
          redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to

          @author = issue.author
          @issue = issue
          @user = user
          @journal = journal
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue)
          subject = "[#{@issue.tracker.name} ##{@issue.id}] You were mentioned in: #{@issue.subject}"
          mail :to => user,
            :subject => subject
        end
      end
    end
  end
end

unless Mailer.included_modules.include?(RedmineMentions::Patches::MailerPatch)
  Mailer.send(:include, RedmineMentions::Patches::MailerPatch)
end
