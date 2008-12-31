ActiveRecord::Schema.define(:version => 1) do

  create_table :people, :force => true do |t|
    t.string    :name
    t.text      :biography
    t.integer   :age
    t.float     :hourly_rate
    t.decimal   :weekly_rate, :precision => 12, :scale => 2
    t.datetime  :signup_datetime
    t.timestamp :signup_timestamp
    t.time      :signup_time
    t.date      :signup_date
    t.binary    :binary_field
    t.boolean   :active
    t.timestamps
  end

end