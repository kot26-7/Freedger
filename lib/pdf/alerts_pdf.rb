class AlertsPdf < Prawn::Document
  def initialize(data)
    super(
      page_size: 'A4',
      top_margin: 20,
      bottom_margin: 20,
      left_margin: 20,
      right_margin: 20
    )
    @data = data

    font 'vendor/assets/fonts/ipaexg.ttf'

    header

    list_items

    footer
  end

  def header
    text 'Alerts list', size: 20
    move_down 10
  end

  def list_items
    table list_item_rows do
      cells.size = 12
      row(0).align = :center
      row(0).background_color = 'ffc492'
      columns(0..3).width = 135
    end
  end

  def list_item_rows
    [['Type', 'Container-name', 'Product-name', 'Expiration-date']] +
    @data.map do |n|
      [n.action, n.container.name, n.product.name, n.product.product_expired_at]
    end
  end

  def footer
    page_count.times do |i|
      bounding_box([bounds.left, bounds.bottom], width: bounds.width, height: 30) do
        go_to_page(i + 1)
        text "#{i + 1}/#{page_count}", align: :center
      end
    end
  end
end
