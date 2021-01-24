Config = {}

Config['Settings'] = {
    ['Subtitles'] = true, -- show subtitles in the cutscene?
    ['Ped'] = 'a_m_m_afriamer_01',
    ['Animation'] = {
        ['Dict'] = 'mp_player_inteat@burger', 
        --['Anim'] = 'mp_player_int_eat_burger_fp',
    },
    ['Audio'] = 'https://streamable.com/watu6o', -- audio url
    ['TransmitterLength'] = 600, -- how many seconds it takes to disconnect the transmitter (how long the cops will be alerted)
    ['Deliver'] = vector3(1099.74, -785.06, 56.86),
    ['SelfDelay'] = 5 * 60 * 60 --[[5 hours]], -- seconds between carthief (for the player who just did it)
    ['ServerDelay'] = 30 * 60 --[[30 minutes]], -- seconds between carthief (for everyone on the server)
    ['Cops'] = 1, -- cops required to start carthief
    ['Reward'] = {
        ['Min'] = 4000,
        ['Max'] = 6000,
    }
}

Config['Cutscenes'] = {
    ['Start'] = {
        ['Ped'] = vector4(1122.9715576172, -1304.5726318359, 33.716415405273, 351.77963256836),
        ['Camera'] = vector3(1126.8150634766, -1299.1595458984, 36.985511779785),
        ['Self'] = vector4(1123.2987060547, -1302.0083007813, 33.716415405273, 168.7357635498),
        ['Length'] = 12000, -- hur länge cutscenen ska visas
    },
}

Config['Vehicles'] = {
    ['Positions'] = { -- possible spawn locations for cars
        vector4(2739.8088378906, 1330.0183105469, 24.111238479614, 359.66198730469),
        vector4(-105.05442047119, 823.89538574219, 235.31307983398, 10.589683532715)
    },

    ['Models'] = { -- possible vehicle models
        '2016rs7',
        't20',
        'michelli',
        'v60'
    }
}

Config['Subtitles'] = {
    ['Start'] = {
        {0, 2000, 'ja tjenare.'},
        {2750, 4250, 'Jag vill att du ska sno en bil åt mig.'},
        {4500, 7750, 'När du har snott den kingen, kom då till mig så ska du få din belöning.'},
        {8500, 10000, 'Och du, krocka inte.'},
        {10000, 12000, 'Se upp för polisen för fan kingen!'}
    }
}

Strings = {
    ['Start'] = 'Prata med Zbigeniew',
    ['Cancel'] = 'Avbryt bilstöld',
    ['Hotwire'] = 'Tjuvkoppla bilen (%s)',
    ['Lockpick'] = 'Dyrka låset (%s)',
    ['GetToCar'] = 'Ta dig till den markerade ~r~positionen~s~.',
    ['Deliver'] = 'Ta bilen till den markerade ~g~positionen~s~.',
    ['GetOut'] = 'Hoppa ut ur bilen.',
    ['Transmitter'] = 'Kopplar loss sändaren. ~r~%s~s~ sekunder kvarstår. Se upp för polisen!',
    ['Police'] = 'Någon har stulit en bil! Kolla din GPS.',
    ['SomeoneStealing'] = 'Någon håller redan på att stjäla en bil!',
    ['YouStole'] = 'Du stal nyss en bil! Du måste vänta mer innan du kan stjäla en bil igen.',
    ['SomeoneStole'] = 'Någon stal precis en bil, du måste vänta inann du kan stjäla en bil.',
    ['NoCops'] = 'Det är inte tillräckligt med poliser online.',
    ['Reward'] = 'Din belöning skulle vara: ~g~%s:-~s~, men på grund av skadorna på bilen får du: ~g~%s:-'
}