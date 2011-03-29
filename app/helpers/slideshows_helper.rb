module SlideshowsHelper

  def insert_slideshow(params={})
    @content_for_head_added ||= false

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
    if (params[:arrows])
      add_arrows = <<-links
      <a href="#" class="prev"><img src="/images/arrow-prev.png" height="#{params[:arrow_size]}" alt="Arrow Prev"></a>
      <a href="#" class="next"><img src="/images/arrow-next.png" height="#{params[:arrow_size]}" alt="Arrow Next"></a>
      links
    end

    slides_div = content_tag :div, :id => "#{params[:div_id]}" do
      [content_tag(:div, slide_images(params), :class => "slides_container"), add_arrows].join("\n")
    end

    add_frame = ""
    if (params[:frame])
      add_frame = <<-frame
                  <img src="/images/frame.png" width="#{params[:width]}" height="#{params[:height]}" alt="Example Frame" id="frame">
                  frame
    end

    content_tag :div, :class => "slideshow" do
      [slides_div, add_frame].join("\n")
    end

  end

  def slide_images(params)
      max = params[:max]
      group = params[:group]
      if not params[:taxon]
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
