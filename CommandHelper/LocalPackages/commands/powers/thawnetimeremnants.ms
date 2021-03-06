register_command('thawnetimeremnants', 
    array(
        'description': 'Power',
        'permission': 'powers.thawnetimeremnants',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 0) {
                return(false)
            }
            
            @player = player()

            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('thawnetimeremnants',10,@player)){
                return()
            }

            @oldMobs = import(@player.'thawnetimeremnantsClones')
            if(is_array(@oldMobs)){
                foreach(@mob in @oldMobs){
                    try(entity_remove(@mob),continue())
                }
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @class = _getheroclass(@player)            
            @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
            @hero = yml_decode(@contents)
            @sig = @hero['costumes'][0]['sig']
            @val = @hero['costumes'][0]['val']

            @mobUUIDs = spawn_mob('wolf:tamed',15)
            export(@player.'thawnetimeremnantsClones',@mobUUIDs)
            set_timeout(50,closure(
                foreach(@uuid in @mobUUIDs){
                    queue_push(closure(runas('~console',"/disguiseplayer ".@uuid.' player '.@player.' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@sig.'","name":"textures","value":"'.@val.'"}]}')))
                    tame_mob(@player,@uuid)
                    set_mob_effect(@uuid, 21, 4, 9999, true, false)
                    set_mob_effect(@uuid, 1, 4, 9999, true, false)
                }
            ))
        }
    )
)
