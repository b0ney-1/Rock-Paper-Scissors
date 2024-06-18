module metaschool::RockPaperScissors_e {
    use std::string::{String,utf8};
    use std::signer;
    use aptos_framework::randomness;

    struct DuelResult has key
    {
        computer_selection: String,
        duel_result: bool
    }

    public entry fun createGame(account: &signer)acquires DuelResult { 
        if (exists<DuelResult>(signer::address_of(account))){
            let brain = borrow_global_mut<DuelResult>(signer::address_of(account));
            brain.computer_selection = utf8(b"New Game Created");  
            brain.duel_result = true;
        }
        else {
            let brain = DuelResult { computer_selection: utf8(b"New Game Created") , duel_result:true };
            move_to(account, brain);
        }
    }

    #[randomness]
    entry fun duel(account: &signer, user_selection: String) acquires DuelResult {
        let random_number = randomness::u64_range(0, 3); // 3 is exclusive
        let result = borrow_global_mut<DuelResult>(signer::address_of(account));
        if(random_number==0)
        {
            result.computer_selection = utf8(b"Rock");
        }
        else
        {
            if(random_number==1)
            {
                result.computer_selection = utf8(b"Paper");
            }
            else
            {
                result.computer_selection = utf8(b"Scissors");
            }
        }   

        let computer_selection = &brain.computer_selection;

        if (user_selection == *computer_selection) {
            brain.duel_result = false; // tie
        } else if ((user_selection == utf8(b"Rock") && *computer_selection == utf8(b"Scissors")) ||
                   (user_selection == utf8(b"Paper") && *computer_selection == utf8(b"Rock")) ||
                   (user_selection == utf8(b"Scissors") && *computer_selection == utf8(b"Paper"))) {
            brain.duel_result = true; // User wins
        } else {
            brain.duel_result = false; // Computer wins
        }
    }
}
