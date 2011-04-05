module SlideshowsHelper

  def insert_slideshow(params={})
    @content_for_head_added ||= false
    params[:group]||=""
    params[:max]||=5
    params[:arrows]||=true
    params[:frame]||=true
    params[:id]||="slider"
    params[:arrow_size]||=24
    params[:width]||=739
    params[:height]||=341
    params[:taxon]||=false
    params[:image_height]||=false
    params[:image_width]||=false
    params[:fx]||=''
    params[:build_arrows]||=false
    params[:build_navigation]||=false
    params[:start_stopped]||=false
    params[:auto_play]||=true

    content = ''
    output = ''

    content_for :head do
      unless @content_for_head_added
      %( <%= javascript_tag do %>
          $(function(){
            $('##{params[:id]}')
            .anythingSlider({
              width: #{params[:width]},
              height: #{params[:height]},
              resizeContents: false,
              easing: "easeInOutExpo",
              autoPlay: #{params[:auto_play]},
              delay: 7000,                       // How long between slide transitions (autoPlay mode only)
              startStopped: #{params[:start_stopped]},               // Start stop if autoPlay
              animationTime: 600,                // How long the slide transition takes
              hashTags: false,                   // Should links change the hashtag in the URL?
              buildArrows: #{params[:build_arrows]},
              toggleArrows: true,                // Show nav arrows on hover else hide
              buildNavigation: false,            // If true, builds a list of anchor links to link to each slide
              pauseOnHover: true,
              startText: "",
              stopText: "",
              navigationFormatter: formatText    // Details in anythingslider source
            })
            .anythingSliderFx({
              // base FX definitions
              '.fade'         : [ 'fade' ]
            });
          });
        <% end %>)
        @content_for_head_added = true
      end
    end

    output << content_tag(:ul, content.html_safe, :id => "#{params[:id]}", :class => 'anythingSlider') do
      content_tag(:div, content_tag(:ul, slide_panels(params).html_safe), :class => 'wrapper')
    end

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
          
          content_tag(:li, link_to(product_image(product, img_options)+raw("<h3 class='product-title'>#{product.name}</h3>"), product, :class => 'product-image', :title => product.name))
        end.join("\n")
      end
  end

end
