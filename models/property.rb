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
    return properties.map {|property| Property.new(property)}
  end

  def delete()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "DELETE FROM properties WHERE id = $1;"
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close
  end

  def Property.delete_all()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "DELETE FROM properties;"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def update()
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql =
    "
    UPDATE properties SET (
      value,
      number_of_bedrooms,
      build,
      buy_let_status
      ) = (
        $1,
        $2,
        $3,
        $4
      ) WHERE id = $5;"
      values = [@value, @number_of_bedrooms, @build, @buy_let_status, @id]
      db.prepare("update", sql)
      db.exec_prepared("update", values)
      db.close
  end

  def Property.find(id)
    db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
    sql = "SELECT * FROM properties WHERE id = $1;"
    values = [id]
    db.prepare("find", sql)
    results_array = db.exec_prepared("find", values)
    db.close
    return nil if results_array.first() == nil
    property_hash = results_array[0]
    found_property = Property.new(found_property)
    return found_property
  end
  #
  # def find_by_build(build)
  #   db = PG.connect({dbname: 'property_tracker', host: 'localhost'})
  #   sql = "SELECT * FROM properties WHERE build = #{build}"
  #   values = [@build]
  #   db.prepare("find", sql)
  #   properties = db.exec_prepared("find", values)
  #   db.close
  #   return properties.map {|property| Property.new(property)}
  # end

end
