class UIImage
  
  # Resize Image
  # target_size: Array or CGSize
  # upscale: Boolean (false = do not upscale image)
  #
  # Code ideas from http://stackoverflow.com/questions/15653953/resize-image-in-iphone
  #
  def resize_image_to_size(target_size, upscale=true)
    image_size = self.size
    
    # convert Array to CGSize
    if target_size.is_a?(Array)
      target_size = CGSizeMake(target_size[0], target_size[1])
    end
    # when target_size no CGSize set to image_size
    unless target_size.is_a?(CGSize)
      target_size = image_size
    end
    
    # do not upscale when requested
    if !upscale and (target_size.width > image_size.width or target_size.height > image_size.height)
      target_size = image_size
    end
    
    unless CGSizeEqualToSize(image_size, target_size)
      width_factor = target_size.width / image_size.width
      height_factor = target_size.height / image_size.height
      if width_factor < height_factor
        target_size.height = image_size.height * width_factor
      else
        target_size.width = image_size.width * height_factor
      end
    end
    
    UIGraphicsBeginImageContext(target_size)
    resize_rect = CGRectMake(0, 0, target_size.width, target_size.height)
    self.drawInRect resize_rect
    resized_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    resized_image
  end
  
end