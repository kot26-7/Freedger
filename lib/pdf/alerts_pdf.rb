class AlertsPdf < Prawn::Document
  def initialize(data)
    super(
      page_size: 'A4',
      top_margin: 40,
      bottom_margin: 30,
      left_margin: 20,
      right_margin: 20
    )
    @data = data

    font 'vendor/assets/fonts/ipaexg.ttf'

    stroke_axis
  end
end
