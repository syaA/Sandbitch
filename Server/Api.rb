# coding: utf-8

class ApiApp
  def call(env)
    p(env)
    case env['REQUEST_METHOD']
    when 'GET'
      [
        200,
        {'Content-Type' => 'text/html'},
        #['<html><body><form method="POST"><input type="submit" value="see?"></form></body></html>']
        env.keys.sort.map { |k| "#{k} = #{env[k]}<br>" } +
        Rack::Utils.parse_nested_query(env['QUERY_STRING']).map { |k,v| "#{k} = #{v}<br>" }
      ]
    when 'POST'
      [
        200,
        {'Content-Type' => 'text/html'},
        ['<html><body>see.</body></html>']
      ]
    end
  end
end
