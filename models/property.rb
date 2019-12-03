require('pg')

class Property

  attr_reader :id
  attr_accessor :value, :number_of_bedrooms, :build, :buy_let_status

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @value = options['value']
    @number_of_bedrooms = options['number_of_bedrooms'].to_i()
    @build = options['build']
    @buy_let_status = options['buy_let_status']
  end

  def save()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql =
    "
    INSERT INTO properties (
      value,
      number_of_bedrooms,
      build,
      buy_let_status
    ) VALUES (
      $1,
      $2,
      $3,
      $4
    ) RETURNING id;
    "
    values = [@value, @number_of_bedrooms, @build, @buy_let_status]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]['id'].to_i
    db.close()

  end

  def Property.all()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "SELECT * FROM properties;"
    db.prepare("all", sql)
    properties = db.exec_prepared("all")
    db.close
    return properties.map{|property| Property.new(property)}
  end

end
