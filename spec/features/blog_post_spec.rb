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

      it "Allows the user to delete that blog post" do
        within ".admin-panel .blog_posts" do
          click_link "Destroy"
        end

        expect(page).to have_content "Blog post was successfully destroyed."
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
end
