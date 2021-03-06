#############################################################################
# Copyright © 2010 Dan Wanek <dan.wanek@gmail.com>
#
#
# This file is part of Viewpoint.
# 
# Viewpoint is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# 
# Viewpoint is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with Viewpoint.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################

module Viewpoint
  module EWS
    class CalendarFolder < GenericFolder

      # Find folders of type Task
      # @see GenericFolder.find_folders
      # @param [String,Symbol] root An folder id, either a DistinguishedFolderId (must me a Symbol)
      #   or a FolderId (String)
      # @param [String] traversal Shallow/Deep/SoftDeleted
      # @param [String] shape the shape to return IdOnly/Default/AllProperties
      # @param [optional, String] folder_type an optional folder type to limit the search to like 'IPF.Task'
      # @return [Array] Returns an Array of Folder or subclasses of Folder
      def self.find_folders(root = :msgfolderroot, traversal = 'Deep', shape = 'Default', folder_type = 'IPF.Appointment')
        super(root, traversal, shape, folder_type)
      end


      # initialize with an item of CalendarFolderType
      def initialize(folder)
        super(folder)

        # @todo Handle:
        #   <SharingEffectiveRights/>
      end

      # Fetch only items from today (since midnight)
      def todays_items(opts = {})
        #This is a bit convoluted for pre-1.9.x ruby versions that don't support to_datetime
        items_between(DateTime.parse(Date.today.to_s), DateTime.parse((Date.today + 1).to_s), opts)
      end

      # Fetch items since a give DateTime
      # @param [DateTime] start_date_time the time to fetch Items since.
      def items_since(start_date_time, opts = {})
        items_between(start_date_time, DateTime.now, opts)
      end

      # Find Calendar Items between two dates
      # @param [DateTime] start_date the date to start the search from
      # @param [DateTime] end_date the date to end the search at
      # @param [Hash] opts misc opts like restrictions, etc
      def items_between(start_date, end_date, opts = {})
        opts[:calendar_view] = {:max_entries_returned => 256, :start_date => start_date, :end_date => end_date}
        find_items(opts)
      end

    end # CalendarFolder
  end # EWS
end # Viewpoint
