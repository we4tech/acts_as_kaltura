# ActsAsKaltura

Kaltura is SaaS based video streaming platform, officially kaltura ruby API is available [here](http://corp.kaltura.com/Products/Kaltura-API). Another fork could be found [here](https://github.com/Velir/kaltura-ruby).
Based on velir kaltura ruby library, we [somewhere in... ruby devs](http://www.somewherein.net) have built this gem to simplify kaltura video and cuepoint synchronization process.

## acts_as_kaltura_video

![Travis status](https://secure.travis-ci.org/we4tech/acts_as_kaltura.png)

It sync your video model with kaltura MediaEntry. 
 
### Usages - 

```ruby
class Video
  acts_as_kaltura_video :delegate => [:thumbnail_url, :duration]

  # Set media entry object based on your required fields
  def as_kaltura_entry
   Kaltura::MediaEntry.new.tap do |entry|
     entry.name = title
     entry.description = description
     entry.tags = tags.map &:name
     entry.media_type = Kaltura::Constants::Media::Type::VIDEO
   end
 end
end
```
### Video model must includes the following fields - 

> * kaltura_key (string)

> * kaltura_syncd_at (datetime)

if you use `:delegate => [kaltura web service fields]` you have to add fields for each delegatable field.
ie. for `:delegate => [:thumbnail_url]` you have to add `:thumbnail_url` (text) to video model. 

### Create video 
```ruby
Video.create(:title => 'My birthday video', :description => 'Great family moments', :video_file => ..)
```

### Using delegate methods
`Video.first.thumbnail_url` it will check local `thumbnail_url` attribute if not found it will retrieve thumbnail through kaltura web service and it will run `update_column :thumbnail_url, value`.

## acts_as_kaltura_annotation

It will sync your `Annotation` model with kaltura cuepoint annotation object.

### Usages -

```ruby
class Annotation < ActiveRecord::Base
  belongs_to  :video
  acts_as_kaltura_annotation

  def as_annotation_cuepoint
    ActsAsKaltura::Extension::KalturaAnnotation.new.tap do |cp|
      cp.cue_point_type = ActsAsKaltura::Extension::KalturaAnnotation::TYPE_ANNOTATION

      # convert to milliseconds
      cp.start_time = self.start_time.to_i * 1000
      cp.end_time = self.end_time.to_i * 1000

      cp.system_name = self.title
      cp.text = self.description
      cp.entry_id = self.video.kaltura_key
    end
  end
end
```  
### Annotation model must includes the following fields -

> * cuepoint_key (String)

## How to install
> gem install acts_as_kaltura


