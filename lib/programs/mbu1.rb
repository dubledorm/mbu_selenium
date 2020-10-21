module Programs
  module Mbu1

    COMMAND_HASH = { '1' =>
                         { selector: { xpath: '//fieldset[1]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: {},
                           next: { selector: {class: 'next'},
                                   do: 'click'
                           }
                         },
                     '2' =>
                         { selector: { xpath: '//fieldset[2]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_1' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[2]/button' },
                                   do: 'click'
                           }
                         },
                     '3' =>
                         { selector: { xpath: '//fieldset[3]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_2' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[3]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '4' =>
                         { selector: { xpath: '//fieldset[4]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_3' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[4]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '5' =>
                         { selector: { xpath: '//fieldset[5]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_4' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[5]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '6' =>
                         { selector: { xpath: '//fieldset[6]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_5' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[6]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '7' =>
                         { selector: { xpath: '//fieldset[8]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { xpath: '//fieldset[8]/label[2]/input' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[8]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '8' =>
                         { selector: { xpath: '//fieldset[10]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_9' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[10]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '9' =>
                         { selector: { xpath: '//fieldset[11]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_10' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[11]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '10' =>
                         { selector: { xpath: '//fieldset[12]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_11' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[12]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '11' =>
                         { selector: { xpath: '//fieldset[13]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_12' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[13]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '12' =>
                         { selector: { xpath: '//fieldset[14]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_13' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[14]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '13' =>
                         { selector: { xpath: '//fieldset[15]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_14' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[15]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '14' =>
                         { selector: { xpath: '//fieldset[16]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_15' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[16]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '15' =>
                         { selector: { xpath: '//fieldset[17]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_memo_35' },
                                          do: 'send',
                                          value: 'Всё хорошо'}
                           },
                           next: { selector: { xpath: '//fieldset[17]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '16' =>
                         { selector: { xpath: '//fieldset[18]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_radio_17' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[18]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '17' =>
                         { selector: { xpath: '//fieldset[19]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { xpath: '//fieldset[19]/label[5]/input' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[19]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '18' =>
                         { selector: { xpath: '//fieldset[20]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { xpath: '//fieldset[20]/label[2]/input' },
                                          do: 'click' }
                           },
                           next: { selector: { xpath: '//fieldset[20]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '19' =>
                         { selector: { xpath: '//fieldset[21]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_field_45' },
                                          do: 'send',
                                          value: '24' },
                                 '2' => { selector: { xpath: '/html/body/div[5]/div[2]/div/div/div/div/div/div/div[1]/div/div[3]/div/form/div/fieldset[21]/b' },
                                          do: 'click' },
                                 '3' => { selector: { xpath: '//fieldset[21]/label' },
                                          do: 'sleep' }
                           },
                           next: { selector: { xpath: '//fieldset[21]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '20' =>
                         { selector: { xpath: '//fieldset[22]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { name: 'vote_field_47' },
                                          do: 'send',
                                          value: '89161234567' },
                                 '2' => { selector: { xpath: '/html/body/div[5]/div[2]/div/div/div/div/div/div/div[1]/div/div[3]/div/form/div/fieldset[22]/b' },
                                          do: 'click' },
                                 '3' => { selector: { xpath: '//fieldset[22]/label' },
                                          do: 'sleep' }
                           },
                           next: { selector: { xpath: '//fieldset[22]/button[2]' },
                                   do: 'click'
                           }
                         },
                     '21' =>
                         { selector: { xpath: '//fieldset[24]' },
                           validate: { attribute: :visible, value: 'true' },
                           do: { '1' => { selector: { xpath: '//fieldset[24]/div[2]/div[1]/img' },
                                          do: 'read_attribute',
                                          attribute_name: 'src',
                                          storage_name: 'src_path'},
                                 '2' => { selector: { xpath: '//fieldset[24]/div[2]/div[1]/img' },
                                          do: 'resolv_capcha',
                                          storage_src: 'src_path',
                                          storage_name: 'capcha_resolve'
                                 },
                                 '3' => { selector: { xpath: '//fieldset[24]/div[2]/div[2]/input' },
                                          do: 'send',
                                          value_from_storage: 'capcha_resolve' }
                           },
                           next: { selector: { xpath: '//fieldset[24]/button[2]' },
                                   do: 'click'
                           }
                         },
                     # '22' =>
                     #     { selector: { xpath: '//fieldset[25]' },
                     #       validate: { attribute: :visible, value: 'true' },
                     #       do: {},
                     #       next: { selector: { xpath: '/html/body/div[5]/div[2]/div/div/div/div/div/div/div[1]/div/div[3]/div/form/div/fieldset[25]/input' },
                     #               do: 'click'
                     #       }
                     #     },
    }
  end
end