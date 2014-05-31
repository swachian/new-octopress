---
layout: post
title: "What's new in Rails 4"
date: 2012-11-23 22:00
comments: true
categories: 
- rails
- 技术
---

来自[视频](http://vimeo.com/51181496)的笔记

### Rails.queue

```
class ExpensiveOperation
  def run
   
  end
end

Rails.queue.push(ExpensiveOperation.new)


```
config.queue = Sidekiq::Client::Queue #Resque, delayed_job


### strong_parameters
Alternative to MassAssignmentSecurity 

```
class PostsController < ApplicationController
  def create
     @post = Post.create(post_params)
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
  
```

### Turbolinks

### Cache Digests(Russian Doll Caching)

```
# app/views/projects/show.html.erb
<% cache project do %>
  <h1> </h1>
  <%= render project.documents %>
<% end %>
```

### ActionController::Live

```
include ActionController::Live

response.stream.write "hello\n"

```

### PATCH Verb

just as PUT

### Plugins are dead; long live plugins

use gems with bundle

### lambda scope

```
scope :published, -> { where(:published => true) }

#Pitfall 
scoped :recent, where("created_at > ?", 1.week.ago)
```

@sikachu

Routing Concerns 

Long live activeresource 

The changes seem not to be surprising compared with those from Rails 2.3 to Rails 3.0. And perhaps less than from 3.0 to 3.1. 
They are real slight for Rails. I guess this is due to DHH have just had a Colt HH. The same for me!
