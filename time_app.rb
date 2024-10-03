class TimeApp
  AVAILABLE_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info == '/time'
      handle_time_request(request)
    else
      response(404, "Not found")
    end
  end

  private

  def handle_time_request(request)
    formats = request.params['format']&.split(',')
    if formats.nil?
      return response(400, "Format query parameter is missing")
    end

    unknown_formats = formats - AVAILABLE_FORMATS.keys
    if unknown_formats.any?
      return response(400, "Unknown time format [#{unknown_formats.join(', ')}]")
    end

    time_string = formats.map { |format| Time.now.strftime(AVAILABLE_FORMATS[format]) }.join('-')
    response(200, time_string)
  end

  def response(status, body)
    [status, { 'Content-Type' => 'text/plain' }, [body]]
  end
end


