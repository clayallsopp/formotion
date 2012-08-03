class UsersController < UITableViewController
  def users
    @users ||= [User.new("Harry", 100, "Green"),
                User.new("Ron", 80, "Blue"),
                User.new("Hermione", 120, "Red")]
  end

  def viewDidLoad
    super
    self.title = "Scoreboard"
  end

  def viewDidAppear(animated)
    super
    self.users.sort_by! { |x| x.score }.reverse!
    self.tableView.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    self.users.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @identifier ||= "IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@indentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@identifier)
    end

    user = self.users[indexPath.row]
    cell.textLabel.text = "##{indexPath.row + 1}: #{user.name}"
    cell.detailTextLabel.text = user.team
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    user = self.users[indexPath.row]
    alert = UIAlertView.alloc.initWithTitle(user.name, message:"Score: #{user.score}", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
    alert.show
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    # WHERE THE MAGIC HAPPENS!
    user = self.users[indexPath.row]
    controller = Formotion::FormableController.alloc.initWithModel(user)
    self.navigationController.pushViewController(controller, animated:true)
  end
end