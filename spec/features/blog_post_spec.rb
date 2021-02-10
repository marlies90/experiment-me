# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogPost, type: :feature do
  context "CRUDing a blog_post" do
    let(:admin) { FactoryBot.create(:user, :admin) }

    before do
      login_as(admin)
    end

    context "When creating a new blog post" do
      before do
        visit new_blog_post_path
      end

      it "Allows a valid blog post to be created succesfully" do
        fill_in "blog_post_name", with: Faker::Superhero.name
        fill_in "blog_post_summary", with: Faker::Lorem.paragraph
        fill_in "blog_post_description", with: Faker::Lorem.paragraph
        # fill_in "Image", with: Faker::Avatar.image

        click_button "Save blog post"
        expect(page).to have_content "Blog post was successfully created."
      end
    end

    context "When a blog post has been created" do
      let!(:blog_post) { FactoryBot.create(:blog_post) }

      before do
        visit dashboard_admin_path
      end

      it "Allows the user to view that blog post" do
        within ".admin-panel .blog_posts" do
          click_link "Show"
        end

        expect(page).to have_content blog_post.name.to_s
      end

      it "Allows the user to go into editing mode" do
        within ".admin-panel .blog_posts" do
          click_link "Edit"
        end

        expect(page).to have_content "Editing Blog post"
      end

      it "Allows the user to update that blog post" do
        within ".admin-panel .blog_posts" do
          click_link "Edit"
        end

        # fill_in "Image", with: Faker::Avatar.image
        click_button("Save blog post")
        expect(page).to have_content "Blog post was successfully updated."
      end

      it "allows the user to delete that blog post" do
        within ".admin-panel .blog_posts" do
          click_link "Destroy"
        end

        expect(page).to have_content "Blog post was successfully destroyed."
      end
    end

    context "With blog comments" do
      let!(:blog_post) { FactoryBot.create(:blog_post, :with_comments) }

      before do
        visit dashboard_admin_path
      end

      it "destroys the corresponding comments on blog post destroy" do
        expect(BlogPost.count).to be 1
        expect(BlogComment.count).to be 1

        within ".admin-panel .blog_posts" do
          click_link "Destroy"
        end

        expect(BlogPost.count).to be 0
        expect(BlogComment.count).to be 0
      end

      it "allows the user to destroy a single blog comment" do
        expect(BlogComment.count).to be 1
        expect(page).to have_content blog_post.blog_comments.first.comment

        within ".admin-panel .blog_comments" do
          click_link "Destroy"
        end

        expect(page).to have_content "Comment was successfully destroyed"
        expect(BlogComment.count).to be 0
      end
    end
  end

  context "viewing blog_posts" do
    let!(:blog_post_1) { FactoryBot.create(:blog_post) }
    let!(:blog_post_2) { FactoryBot.create(:blog_post) }

    before do
      visit blog_posts_path
    end

    context "when viewing the index page" do
      it "shows a list of blogs posts" do
        expect(page).to have_content blog_post_1.name
        expect(page).to have_content blog_post_1.summary
        expect(page).to have_content blog_post_2.name
        expect(page).to have_content blog_post_2.summary
      end
    end

    context "when viewing the show page" do
      it "shows the complete blog post" do
        click_link "Read more", match: :first
        expect(page).to have_content blog_post_2.name
        expect(page).to have_content blog_post_2.description
      end
    end
  end

  context "creating blog comments" do
    let!(:blog_post_1) { FactoryBot.create(:blog_post) }
    let!(:blog_post_2) { FactoryBot.create(:blog_post) }

    before do
      visit blog_post_path(blog_post_1)
    end

    context "placing a comment" do
      let!(:blog_comment) do
        FactoryBot.create(:blog_comment, :on_blog_post, email: "enthusiasticuser@gmail.com")
      end

      it "does not allow placing a comment without filling in all fields" do
        within ".new_blog_comment" do
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end

        expect(page).to have_content "Author name can't be blank"
        expect(page).to have_content "Email can't be blank"
      end

      it "allows the user to post multiple comments using the same email" do
        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: "enthusiasticuser@gmail.com"
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end

        expect(page).to have_content "Your comment has been posted!"
      end

      it "does not allow bots to spam comments" do
        expect(BlogComment.count).to be 1

        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          fill_in "blog_comment_website", with: Faker::Internet.url
          click_button "Submit"
        end

        expect(BlogComment.count).to be 1
      end

      it "strips comment tags" do
        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: "<script>alert('I am an alert box!!');</script>"
          click_button "Submit"
        end

        expect(page).to have_content "alert('I am an alert box!!')"
        expect(page).not_to have_content "<script>"
      end

      it "sends an event to Google Analytics" do
        event = spy(GoogleAnalyticsEvent)
        expect(GoogleAnalyticsEvent).to receive(:new).and_return(event)

        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end
      end
    end

    context "when placing a comment on a blog post" do
      it "displays the comment" do
        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end

        expect(page).to have_content "Your comment has been posted!"

        within ".existing_comments" do
          expect(page).to have_content "1 Comments"
        end
      end

      it "is saved only for that blog post" do
        within ".new_blog_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end

        visit blog_post_path(blog_post_2)

        within ".existing_comments" do
          expect(page).to have_content "0 Comments"
        end
      end
    end

    context "when placing a comment on a comment" do
      let!(:blog_post_with_comments) { FactoryBot.create(:blog_post, :with_comments) }

      before do
        visit blog_post_path(blog_post_with_comments)
      end

      it "allows a user to reply to a comment" do
        within ".new_comment_on_comment" do
          fill_in "blog_comment_author_name", with: Faker::Name.first_name
          fill_in "blog_comment_email", with: Faker::Internet.email
          fill_in "blog_comment_comment", with: Faker::Lorem.paragraph
          click_button "Submit"
        end

        expect(page).to have_content "Your comment has been posted!"

        within ".existing_comments" do
          expect(page).to have_content "2 Comments"
        end
      end
    end
  end
end
