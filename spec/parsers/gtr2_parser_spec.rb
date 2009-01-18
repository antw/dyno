require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe Dyno::Parsers::GTR2Parser do

  it 'should respond to .parse' do
    Dyno::Parsers::GTR2Parser.should respond_to(:parse)
  end

  it 'should respond to .parse_file' do
    Dyno::Parsers::GTR2Parser.should respond_to(:parse_file)
  end

  it 'should respond to #parse' do
    Dyno::Parsers::GTR2Parser.public_instance_methods.should include('parse')
  end

  # --------------
  # Event parsing.


  describe 'parse_event!' do
    before(:all) do
      @event = Dyno::Parsers::GTR2Parser.parse_file(
        'spec/fixtures/gtr2/header_only.ini'
      )
    end

    it 'should set the mod used' do
      @event.game.should == 'GT Legends'
    end

    it 'should correctly set the game version' do
      # 1.100
      @event.game_version.should == 1.1 # (close enough)
    end

    it 'should correctly set the event time' do
      # 2009/01/15 21:25:31
      @event.time.should == Time.local(2009, 1, 15, 21, 25, 31)
    end

    it 'should correctly set the track' do
      @event.track.should == 'Nuerburgring'
    end

    it 'should not set the track if one could not be discerned' do
      event = Dyno::Parsers::GTR2Parser.parse_file(
        'spec/fixtures/gtr2/header_no_track.ini'
      )

      event.track.should be_nil
    end

    it 'should whine loudly if there is no "Header" section' do
      lambda {
        Dyno::Parsers::GTR2Parser.parse_file(
          'spec/fixtures/gtr2/no_header_section.ini'
        )
      }.should raise_error(Dyno::MalformedInputError)
    end
  end

  # -------------------
  # Competitor parsing.

  describe 'parse_competitors!' do
    before(:all) do
      @event = Dyno::Parsers::GTR2Parser.parse_file(
        'spec/fixtures/gtr2/single_driver.ini'
      )
    end

    it 'should set the driver name correctly' do
      @event.competitors.first.name.should == 'Brooke Evans'
    end

    it 'should set the vehicle correctly' do
      @event.competitors.first.vehicle.should == 'Abarth 1000TC'
    end

    it 'should set the lap count correctly' do
      @event.competitors.first.laps.should == 57
    end

    it 'should convert the race time to a float' do
      @event.competitors.first.race_time.should == 3064.24
    end

    it 'should convert the best lap time to a float' do
      @event.competitors.first.best_lap.should == 50.301
    end

    it "should correctly set the competitors lap times" do
      @event.competitors.first.lap_times.should == [
         70.567, # Lap=( 0,   -1.000, 1:10.567)
        173.678, # Lap=( 1,  110.474, 2:53.678)
         51.933, # Lap=( 2,  284.151, 0:51.933)
         52.017, # Lap=( 3,  336.084, 0:52.017)
         51.391, # Lap=( 4,  388.101, 0:51.391)
         50.933, # Lap=( 5,  439.492, 0:50.933)
         51.078, # Lap=( 6,  490.424, 0:51.078)
         51.198, # Lap=( 7,  541.502, 0:51.198)
         51.226, # Lap=( 8,  592.700, 0:51.226)
         51.048, # Lap=( 9,  643.926, 0:51.048)
         50.619, # Lap=(10,  694.974, 0:50.619)
         50.707, # Lap=(11,  745.593, 0:50.707)
         50.911, # Lap=(12,  796.300, 0:50.911)
         51.164, # Lap=(13,  847.210, 0:51.164)
         58.389, # Lap=(14,  898.374, 0:58.389)
         50.537, # Lap=(15,  956.763, 0:50.537)
         51.526, # Lap=(16, 1007.300, 0:51.526)
         50.850, # Lap=(17, 1058.826, 0:50.850)
         51.110, # Lap=(18, 1109.676, 0:51.110)
         50.539, # Lap=(19, 1160.786, 0:50.539)
         50.834, # Lap=(20, 1211.325, 0:50.834)
         50.747, # Lap=(21, 1262.159, 0:50.747)
         51.428, # Lap=(22, 1312.906, 0:51.428)
         50.301, # Lap=(23, 1364.334, 0:50.301)
         50.658, # Lap=(24, 1414.635, 0:50.658)
         50.681, # Lap=(25, 1465.293, 0:50.681)
         50.710, # Lap=(26, 1515.974, 0:50.710)
         51.151, # Lap=(27, 1566.683, 0:51.151)
         51.321, # Lap=(28, 1617.834, 0:51.321)
         52.063, # Lap=(29, 1669.155, 0:52.063)
         50.639, # Lap=(30, 1721.218, 0:50.639)
         51.135, # Lap=(31, 1771.857, 0:51.135)
         51.001, # Lap=(32, 1822.992, 0:51.001)
         51.648, # Lap=(33, 1873.993, 0:51.648)
         52.716, # Lap=(34, 1925.641, 0:52.716)
         51.361, # Lap=(35, 1978.357, 0:51.361)
         50.680, # Lap=(36, 2029.718, 0:50.680)
         50.842, # Lap=(37, 2080.397, 0:50.842)
         50.552, # Lap=(38, 2131.240, 0:50.552)
         51.529, # Lap=(39, 2181.791, 0:51.529)
         50.987, # Lap=(40, 2233.320, 0:50.987)
         54.226, # Lap=(41, 2284.307, 0:54.226)
         51.379, # Lap=(42, 2338.533, 0:51.379)
         50.680, # Lap=(43, 2389.912, 0:50.680)
         50.629, # Lap=(44, 2440.592, 0:50.629)
         50.645, # Lap=(45, 2491.222, 0:50.645)
         50.832, # Lap=(46, 2541.866, 0:50.832)
         50.488, # Lap=(47, 2592.698, 0:50.488)
         50.728, # Lap=(48, 2643.187, 0:50.728)
         51.133, # Lap=(49, 2693.915, 0:51.133)
         51.035, # Lap=(50, 2745.048, 0:51.035)
         50.612, # Lap=(51, 2796.083, 0:50.612)
         50.669, # Lap=(52, 2846.695, 0:50.669)
         50.849, # Lap=(53, 2897.364, 0:50.849)
         51.833, # Lap=(54, 2948.213, 0:51.833)
         53.271, # Lap=(55, 3000.046, 0:53.271)
         50.831  # Lap=(56, 3053.317, 0:50.831)
      ]
    end

    it 'should correctly sort drivers by their finishing time, and assign their position' do
      event = Dyno::Parsers::GTR2Parser.parse_file(
        'spec/fixtures/gtr2/full.ini'
      )

      [ "Dirk Koch", "Edyta Piotrowski", "Quarantino Angelo",
        "Favian Fl\303\263rez Romo", "Florka Szigeti", "Elizabeth Cole",
        "Amadej Gorski", "Edna Lenardi\304\215", "Aaliyah Vaughan",
        "Zurie Martel", "Harvey Edwards", "Fruzsina Szegedi",
        "Brooke Evans", "Mimi Kanazawa", "Henk Thygesen", "Mari Kaitala",
        "Ralf Holtzmann", "Casandra Lindgren","Paul Godden",
        "Leanne Yamamoto", "Micheal L Cohen", "Lazaro Atkins",
        "Vickie Avila", "Max Holmberg"
      ].each_with_index do |driver, i|
         event.competitors[i].name.should == driver
         event.competitors[i].position.should == i + 1
      end

      [ ["Dirk Koch",                 60, "0:50:49.079",  953.381042],
        ["Edyta Piotrowski",          60, "0:51:01.283", 1001.334045],
        ["Quarantino Angelo",         60, "0:51:13.913",  923.919434],
        ["Favian Fl\303\263rez Romo", 60, "0:51:29.832",  888.234070],
        ["Florka Szigeti",            59, "0:51:05.657",  914.989380],
        ["Elizabeth Cole",            59, "0:52:27.937", 1435.967285],
        ["Amadej Gorski",             58, "0:50:51.446",  919.585510],
        ["Edna Lenardi\304\215",      58, "0:50:54.579",  878.564331],
        ["Aaliyah Vaughan",           58, "0:51:27.133",  869.708801],
        ["Zurie Martel",              58, "0:51:39.759",  890.637634],
        ["Harvey Edwards",            58, "0:52:45.872",  203.332077],
        ["Fruzsina Szegedi",          57, "0:50:52.005",  934.139587],
        ["Brooke Evans",              57, "0:51:04.240",  928.759644],
        ["Mimi Kanazawa",             55, "0:51:20.462",  944.112854],
        ["Henk Thygesen",             52, "DNF",         1226.803223],
        ["Mari Kaitala",              49, "DNF",          480.238708],
        ["Ralf Holtzmann",            42, "DNF",         1118.922363],
        ["Casandra Lindgren",         42, "DNF",         1227.348511],
        ["Paul Godden",               38, "DNF",          520.843872],
        ["Leanne Yamamoto",           37, "DNF",         1369.497681],
        ["Micheal L Cohen",           14, "DNF",          848.236938],
        ["Lazaro Atkins",             13, "DNF",          199.718567],
        ["Vickie Avila",              12, "DNF",          962.172485],
        ["Max Holmberg",               3, "DQ",           907.125916]]
    end
  end
end