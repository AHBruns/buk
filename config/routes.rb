Rails.application.routes.draw do
  scope "/accounts" do
    post "/me" => "accounts#me"
    post "/create" => "accounts#create"
    post "/create_and_login" => "accounts#create_and_login"
    post "/update" => "accounts#update"
    post "/login" => "accounts#login"
    post "/destroy" => "accounts#destroy"
  end
  scope "/grids" do
    post "/create" => "grids#create"
    post "/read" => "grids#read"
    post "/update" => "grids#update"
    post "/destroy" => "grids#destroy"
    post "/list" => "grids#list"
  end
  scope "/cells" do
    post "/create" => "cells#create"
    post "/read" => "cells#read"
    post "/update" => "cells#update"
    post "/destroy" => "cells#destroy"
    post "/list" => "cells#list"
  end
  scope "/books" do
    post "/create" => "books#create"
    post "/shelf" => "books#shelf"
    post "/create_and_shelf" => "books#create_and_shelf"
    post "/unshelf" => "books#unshelf"
    post "/move" => "books#move"
    post "/read" => "books#read"
    post "/update" => "books#update"
    post "/destroy" => "books#destroy"
    post "/list" => "books#list"
  end
end
