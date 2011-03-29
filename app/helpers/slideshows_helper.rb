module SlideshowsHelper

  def insert_slideshow(params={})
    params[:group]||=""
    params[:max]||=5
    params[:arrows]||=true
    params[:frame]||=true
    params[:div_id]||="slides"
    params[:arrow_size]||=24
    params[:width]||=739
    params[:height]||=341
    params[:taxon]||=false
    params[:image_height]||=false
    params[:image_width]||=false

    add_arrows = ""
    #if (params[:arrows])
    #  add_arrows = <<-links
    #  <a href="#" class="prev"><img src="/images/arrow-prev.png" height="#{params[:arrow_size]}" alt="Arrow Prev"></a>
    #  <a href="#" class="next"><img src="/images/arrow-next.png" height="#{params[:arrow_size]}" alt="Arrow Next"></a>
    #  links
    #end

    if params[:group] == 'Home'
      slide_images(params).each { |slide| content << content_tag(:li, content_tag(:a, image_tag(slide.img.url), :title => slide.name, :href => slide.url)) }
      output << content_tag(:div, :class => 'anythingSlider') do
        content_tag(:div, content_tag(:ul, content.html_safe), :class => 'wrapper')
      end
    else
      slide_images(params).each { |slide| content << content_tag(:a, image_tag(slide.img.url), :title => slide.name, :href => slide.url) }
      output << content_tag(:div, content.html_safe, :class => 'Banner')
    end

    output.html_safe

  end

  def slide_images(params)
      max = params[:max]
      group = params[:group]
      unless params[:taxon]
        slides = Slide.included.in_group(group)
        extra_slides = Slide.not_included.in_group(group).sort_by { rand }.slice(0...max-slides.count)
        slides = (slides + extra_slides).sort_by { |slide| slide.position }
      
        slides.map do |slide|
          link_to(image_tag(slide.img.url), slide.url, { :title => slide.name })
        end.join("\n")
      else
        products = Product.in_taxons(params[:taxon]).take(max)

        products.map do |product|
          img_options = {}
          img_options[:height] = params[:image_height] if params[:image_height]
          img_options[:weight] = params[:image_weight] if params[:image_weight]
          
          link_to (product_image(product, img_options)+raw("<h3 class='product-title'>#{product.name}</h3>"), product, :class => 'product-image', :title => product.name)
        end.join("\n")
      end
  end

end
