module SlideshowsHelper

  def insert_slideshow(params={})
    unless Slide.in_group(params[:group])
      return ''
    end
    @@slideshow_count||= 0
    @content_for_head_added ||= false
    params[:group]||=""
    params[:div_id]||="slides"
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
    params[:arrows]||=true
    params[:arrow_size]||=24

    if not @content_for_head_added
      content_for(:head) { stylesheet_link_tag 'slideshow.css' }
      content_for(:head) { javascript_include_tag 'slides.min.jquery.js' }
      @content_for_head_added = true
    end

    #hook :inside_head_scripts do
    scripts =  javascript_tag %{ 
             $(function(){
                        $("##{params[:div_id]}").slides({
                                'preload': '#{params[:preload]}',
                                'preloadImage': '/images/loading.gif',
                                'play': '5000',
                                'pause': '2500',
                                'hoverPause': 'true'
                        });
             });
      }
    #end

    add_arrows = ""
    if (params[:arrows])
      add_arrows = <<-links
      <a href="#" class="prev"><img src="/images/arrow-prev.png" height="#{params[:arrow_size]}" alt="Previous" /></a>
      <a href="#" class="next"><img src="/images/arrow-next.png" height="#{params[:arrow_size]}" alt="Next" /></a>
      links
    end

    slides_div = ""
    slides_div << content_tag( :div, :id => "#{params[:div_id]}") do
      content_tag(:div, slide_images(params), :class => "slides_container")+add_arrows.html_safe
    end

    add_frame = ""
    if (params[:frame])
      add_frame = <<-frame
                  <img src="/images/frame.png" width="#{params[:width]}" height="#{params[:height]}" alt="Example Frame" id="frame" />
                  frame
    end

    output = ''
      
    @@slideshow_count += 1
    output << content_tag( :div, [slides_div, add_frame, scripts].join("\n").html_safe, :class => "slideshow", :id => "#{params[:div_id]}_#{@@slideshow_count}")
           
    output.html_safe

  end

  def slide_images(params)
      max = params[:max]
      group = params[:group]
      unless params[:taxon]
        slides = Slide.included.in_group(group)
        extra_slides = Slide.not_included.in_group(group).sort_by { rand }.slice(0...max-slides.count)
        slides = (slides + extra_slides).sort_by { |slide| slide.position }
      
        output = slides.map do |slide|
          if slide.img.present? and slide.img.url.present?
            link_to(image_tag(slide.img.url), slide.url, { :title => slide.name })
          else
            content_tag(:div, slide.content.html_safe, :class => 'textSlide')
          end
        end.join("\n")
        raw(output)
      else
        products = Product.in_taxons(params[:taxon]).take(max)

        output = products.map do |product|
          img_options = {}
          img_options[:height] = params[:image_height] if params[:image_height]
          img_options[:weight] = params[:image_weight] if params[:image_weight]
          
          link_to(product_image(product, img_options)+raw("<h3 class='product-title'>#{product.name}</h3>"), product, :class => 'product-image', :title => product.name)
        end.join("\n")
        raw(output)
      end
  end

end
