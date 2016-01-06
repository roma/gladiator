#Gladiator - GUI management system for ROMA

This library is written in almost Ruby, provides GUI control system of ROMA.

## Features

* Cluster controlling
  * enable to check Cluster status(cluster architecture, nodes information, data rate, etc...)
  * enable to execute Recover, Release, rbalse operations and check status of this.
* Instance setting
  * enable to check instance setting value.
  * enable to change these setting dynamically.
* Check Routing data
  * enable to check current & past routing data.
  * enable to get routing history.
  * enable to download routing information via web application.
* Check Logs data
  * enable to check Log data of ROMA.
  * also can sort and filtering
* Connection Glaph
  * enable to check connection counts changing of each nodes
  * enable to check connectino resource rate
* Data management
  * enable to execute set, get.
  * enable to check and command generate of snapshot.

## Documentation

* Refer to [Gladiator documentations](http://roma-kvs.org/gladiator.html)

## Requirements
* Basic Rails Web application Environments.
  * Apahce 2.X (recommend) ,nginx or WEBric
  * Passenger or etc...
* Rails => 4.0.2(recommend)
* Ruby => 2.1.2(recommend)
* ROMA
  * v1.3.0 : Full support(recommend)
  * v1.0.0~ : Full support 
  * v0.8.11 ~ v0.8.14 : Some functions are limited
  * ~v0.8.10 : Can not use 

## Contributing

If you would like to contribute, please...

1. Fork.
2. Make changes in a branch & add unit tests.
3. boot Gladiator and ROMA
4. Run Unit Test
  * run `rspec spec/models/roma_spec.rb`
  * run `rspec spec/controllers/api_controller_spec.rb`  
 (if unit test fails, please check 'lib/config_gui.rb'. If it has no prob, run it again - it's fickle).
5. Create a pull request.

Contributions, improvements, comments and suggestions are welcome!
