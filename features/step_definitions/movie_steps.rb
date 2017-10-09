# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)

  all('input[type=checkbox]').each do |rating|
    if rating.checked? then #check if rating checkbox is checked
        rating.click #uncheck checked boxed
    end
  end
  ratings = arg1.split(', ')
  ratings.each {|rating| check('ratings_'+rating)}
  click_button('ratings_submit')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  checked_ratings = Set.new
  arg1.split(', ').each { |rating| checked_ratings.add(rating) }
  
  unchecked_ratings = Set.new ['G', 'PG', 'PG-13', 'NC-17', 'R']
  unchecked_ratings -= checked_ratings

  result = true
  all("tr").each do |tr|
    unchecked_ratings.each do |rating|
      if tr.text.include?(" #{rating} ")
        result = false
      end
    end
  end
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  allMovies = Movie.all.size
  (page.all("table tr").count - 1).should == allMovies
end

When /^I want to sort movies alphabetically$/ do
  click_on 'Movie Title'
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |firstMovie, secondMovie|
  match = /#{firstMovie}.*#{secondMovie}/m =~ page.body
  expect(match).to be_truthy
end

When /^I want to sort movies by release date$/ do
  click_on 'Release Date'
end