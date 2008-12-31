require File.join(File.dirname(__FILE__), 'test_helper')

class Person < ActiveRecord::Base
end

class GvizSerializerTest < Test::Unit::TestCase #ActiveSupport::TestCase
  fixtures :people
  
  def test_should_serialize_record_to_gviz_partial
    expected = "{c:[{v:'true'},{v:30},{v:'John Doe's Biography'},{v:new Date(2008,1,1,0,0,0)},{v:76.54},{v:1},{v:'John Doe'},{v:new Date(2008,1,1)},{v:new Date(2008,1,1,0,0,0)},{v:[0,0,0]},{v:new Date(2008,1,1,0,0,0)},{v:new Date(2008,1,1,0,0,0)},{v:1234.56}]}"
    assert_equal expected, people(:person_1).to_gviz
  end
  
  def test_should_serialize_collection_to_gviz
    expected = "google.visualization.Query.setResponse({version:'0.5',table:{cols:[{id:'active',label:'Active',type:'boolean'},{id:'age',label:'Age',type:'number'},{id:'biography',label:'Biography',type:'string'},{id:'created_at',label:'Created at',type:'datetime'},{id:'hourly_rate',label:'Hourly rate',type:'number'},{id:'id',label:'Id',type:'number'},{id:'name',label:'Name',type:'string'},{id:'signup_date',label:'Signup date',type:'date'},{id:'signup_datetime',label:'Signup datetime',type:'datetime'},{id:'signup_time',label:'Signup time',type:'timeofday'},{id:'signup_timestamp',label:'Signup timestamp',type:'datetime'},{id:'updated_at',label:'Updated at',type:'datetime'},{id:'weekly_rate',label:'Weekly rate',type:'number'}],rows:[{c:[{v:'true'},{v:30},{v:'John Doe's Biography'},{v:new Date(2008,1,1,0,0,0)},{v:76.54},{v:1},{v:'John Doe'},{v:new Date(2008,1,1)},{v:new Date(2008,1,1,0,0,0)},{v:[0,0,0]},{v:new Date(2008,1,1,0,0,0)},{v:new Date(2008,1,1,0,0,0)},{v:1234.56}]},{c:[{v:'false'},{v:25},{v:'Jane Doe's Biography'},{v:new Date(2008,2,1,1,0,0)},{v:65.43},{v:2},{v:'Jane Doe'},{v:new Date(2008,2,1)},{v:new Date(2008,2,1,1,0,0)},{v:[1,0,0]},{v:new Date(2008,2,1,1,0,0)},{v:new Date(2008,2,1,1,0,0)},{v:123.45}]}]}});"
    assert_equal expected, Person.find(:all).to_gviz
  end
  
  def test_should_include_req_id
    expected = "google.visualization.Query.setResponse({version:'0.5',reqId:'abc123',table:{cols:[{id:'active',label:'Active',type:'boolean'},{id:'age',label:'Age',type:'number'},{id:'biography',label:'Biography',type:'string'},{id:'created_at',label:'Created at',type:'datetime'},{id:'hourly_rate',label:'Hourly rate',type:'number'},{id:'id',label:'Id',type:'number'},{id:'name',label:'Name',type:'string'},{id:'signup_date',label:'Signup date',type:'date'},{id:'signup_datetime',label:'Signup datetime',type:'datetime'},{id:'signup_time',label:'Signup time',type:'timeofday'},{id:'signup_timestamp',label:'Signup timestamp',type:'datetime'},{id:'updated_at',label:'Updated at',type:'datetime'},{id:'weekly_rate',label:'Weekly rate',type:'number'}],rows:[{c:[{v:'true'},{v:30},{v:'John Doe's Biography'},{v:new Date(2008,1,1,0,0,0)},{v:76.54},{v:1},{v:'John Doe'},{v:new Date(2008,1,1)},{v:new Date(2008,1,1,0,0,0)},{v:[0,0,0]},{v:new Date(2008,1,1,0,0,0)},{v:new Date(2008,1,1,0,0,0)},{v:1234.56}]},{c:[{v:'false'},{v:25},{v:'Jane Doe's Biography'},{v:new Date(2008,2,1,1,0,0)},{v:65.43},{v:2},{v:'Jane Doe'},{v:new Date(2008,2,1)},{v:new Date(2008,2,1,1,0,0)},{v:[1,0,0]},{v:new Date(2008,2,1,1,0,0)},{v:new Date(2008,2,1,1,0,0)},{v:123.45}]}]}});"
    assert_equal expected, Person.find(:all).to_gviz(:req_id => "abc123")
  end
  
  def test_returns_no_results_error_for_empty_collections
    expected = "google.visualization.Query.setResponse({version:'0.5',status:'error',errors:[{reason:'other',message:'No results'}]});"
    assert_equal expected, Person.find(:all, :conditions => {:name => "nonexistent"}).to_gviz
  end
  
  def test_should_allow_attribute_filtering_with_only
    expected = "google.visualization.Query.setResponse({version:'0.5',table:{cols:[{id:'active',label:'Active',type:'boolean'}],rows:[{c:[{v:'true'}]},{c:[{v:'false'}]}]}});"
    assert_equal expected, Person.find(:all).to_gviz(:only => :active)
  end
  
  def test_should_allow_attribute_filtering_with_except
    expected = "google.visualization.Query.setResponse({version:'0.5',table:{cols:[{id:'age',label:'Age',type:'number'},{id:'biography',label:'Biography',type:'string'},{id:'created_at',label:'Created at',type:'datetime'},{id:'hourly_rate',label:'Hourly rate',type:'number'},{id:'id',label:'Id',type:'number'},{id:'name',label:'Name',type:'string'},{id:'signup_date',label:'Signup date',type:'date'},{id:'signup_datetime',label:'Signup datetime',type:'datetime'},{id:'signup_time',label:'Signup time',type:'timeofday'},{id:'signup_timestamp',label:'Signup timestamp',type:'datetime'},{id:'updated_at',label:'Updated at',type:'datetime'},{id:'weekly_rate',label:'Weekly rate',type:'number'}],rows:[{c:[{v:30},{v:'John Doe's Biography'},{v:new Date(2008,1,1,0,0,0)},{v:76.54},{v:1},{v:'John Doe'},{v:new Date(2008,1,1)},{v:new Date(2008,1,1,0,0,0)},{v:[0,0,0]},{v:new Date(2008,1,1,0,0,0)},{v:new Date(2008,1,1,0,0,0)},{v:1234.56}]},{c:[{v:25},{v:'Jane Doe's Biography'},{v:new Date(2008,2,1,1,0,0)},{v:65.43},{v:2},{v:'Jane Doe'},{v:new Date(2008,2,1)},{v:new Date(2008,2,1,1,0,0)},{v:[1,0,0]},{v:new Date(2008,2,1,1,0,0)},{v:new Date(2008,2,1,1,0,0)},{v:123.45}]}]}});"
    assert_equal expected, Person.find(:all).to_gviz(:except => :active)
  end
end
