module metaschool::RockPaperScissors {
    use std::string::{String,utf8};
    use std::signer;
    use aptos_framework::randomness;

    struct DuelResult has key
    {
        computer_selection: String,
        duel_result: bool
    }

    public entry fun createGame(account: &signer)acquires DuelResult
    { 
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

 
    public entry fun generateRandomSelection(account: &signer)acquires DuelResult  {
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
                result.computer_selection = utf8(b"Scissor");
            }
        }
        
    }

}
