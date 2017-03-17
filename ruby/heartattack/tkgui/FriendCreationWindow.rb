require 'Observer'
require 'GUI'
require 'Friend'

class FriendList < Model
	def initialize
		@friends = []
	end
	def friends
		return @friends
	end
	def get(index)
		return @friends[index]
	end
	def append(friend)
		@friends << friend
		notifyObservers
	end
	def remove(index)
		@friends.delete_at index
		notifyObservers
	end
	def each(&block)
		@friends.each &block
	end
end

class FriendCreationWindow < TkFrame
	def initialize(parent)
		super(parent)

		relief 'raised'
		borderwidth 1
		fill 'both'
		anchor 'nw'
		expand true

		heading = TkLabel.new(self)
		heading.set 'Friend Creation'
		heading.side 'top'
		heading.anchor 'nw'
		heading.pack

		@currentFriendFrame = TkFrame.new(self)
		friendListFrame = TkFrame.new(self)

		@currentFriendFrame.side 'left'
		@currentFriendFrame.expand true
		@currentFriendFrame.fill 'both'
		@currentFriendFrame.pack

		friendListFrame.side 'right'
		friendListFrame.relief 'raised'
		friendListFrame.border 1
		friendListFrame.fill 'both'
		friendListFrame.pack

		@friendListBox = TkScrollbox.new(friendListFrame, 'height' => 20, 'width' => 20)
		@friendListBox.side 'top'
		@friendListBox.bind 'Double-Button-1' do
			index = @friendListBox.curselection[0]
			if index != nil
				displayFriend(@friendList.get(index))
			end
		end
		@friendListBox.pack
		
		buttonFrame = TkFrame.new(friendListFrame)
		buttonFrame.side 'top'
		buttonFrame.pack

		addRandomButton = TkButton.new(buttonFrame)
		addRandomButton.set 'Add a Random Friend'
		addRandomButton.side 'top'
		addRandomButton.anchor 'w'
		addRandomButton.fill 'x'
		addRandomButton.command {
			@friendList.append(Friend.newRandom)
		}
		addRandomButton.pack

		addCustomButton = TkButton.new(buttonFrame)
		addCustomButton.set 'Add a Custom Friend'
		addCustomButton.side 'top'
		addCustomButton.anchor 'w'
		addCustomButton.fill 'x'
		addCustomButton.command {
			@friendList.append(Friend.new)
		}
		addCustomButton.pack

		addDeleteButton = TkButton.new(buttonFrame)
		addDeleteButton.set 'Delete Selected Friend'
		addDeleteButton.side 'top'
		addDeleteButton.anchor 'w'
		addDeleteButton.fill 'x'
		addDeleteButton.command {
			index = @friendListBox.curselection[0]
			@friendList.remove(index) if index
		}
		addDeleteButton.pack


		# Okay button
		okay = TkButton.new(friendListFrame)
		okay.text 'Okay'
		okay.borderwidth 1
		okay.side 'bottom'
		okay.command {
			if okayValid then
				nextStep
			end
		}
 		okay.pack

		@friendList = FriendList.new
		@friendList.addObserver(self)
	end

	def displayFriend(friend)
		puts 'Displaying ' + friend.type.to_s
	end

	def okayValid
	end

	def nextStep
		p 'move onto next step'
		saveValues
	end
	
	def saveValues
	end

	def update(model)
		# Get the index of the last item
		last = @friendListBox.size - 1
		# Delete all items in the box (first to last).
		@friendListBox.delete(0, last)
		
		# Re add all the items from the model.
		model.each { |friend|
			@friendListBox.insert('end', friend)
		}
	end
end
