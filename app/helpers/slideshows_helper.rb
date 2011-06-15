module SlideshowsHelper

  def insert_slideshow(params={})
    unless Slide.in_group(params[:group])
      return ''
    end
    @@slideshow_count||= 0
    params[:group]||=""
    params[:id]||="slider"
    params[:width]||=739
    params[:height]||=341
    params[:taxon]||=false
    params[:image_height]||=false
    params[:image_width]||=false
    params[:fx]||=''
    params[:build_navigation]||=false
    params[:start_stopped]||=false
    params[:auto_play]||=true
    params[:max]||=5

    theslides = slide_panels(params)
    unless theslides.present?
        return ''
    end

    output = ''

    @@slideshow_count += 1
    output << content_tag(:div, theslides.html_safe, :class => '.slideshow', :id => "#{params[:id]}_#{@@slideshow_count}")

    output.html_safe

  end

  def slide_panels(params)
      max = params[:max]
      group = params[:group]
      unless params[:taxon]
        slides = Slide.included.in_group(group)
        extra_slides = Slide.not_included.in_group(group).sort_by { rand }.slice(0...max-slides.count)
        slides = (slides + extra_slides).sort_by { |slide| slide.position }
      
        slides.map do |slide|
          if slide.img.present? and slide.img.url.present?
            link_to(image_tag(slide.img.url), slide.url, { :title => slide.name })
          else
            content_tag(:div, slide.body.html_safe, :class => 'textSlide')
          end
        end.join("\n")
      else
        products = Product.in_taxons(params[:taxon]).take(max)

        products.map do |product|
          img_options = {}
          img_options[:height] = params[:image_height] if params[:image_height]
          img_options[:weight] = params[:image_weight] if params[:image_weight]
          
          link_to(product_image(product, img_options)+raw("<h3 class='product-title'>#{product.name}</h3>"), product, :class => 'product-image', :title => product.name)
        end.join("\n")
      end
  end

end
