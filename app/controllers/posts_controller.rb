class PostsController < ApplicationController
def index
    @posts = Post.all  # This fetches all posts (assuming a Post model exists)
end
end
