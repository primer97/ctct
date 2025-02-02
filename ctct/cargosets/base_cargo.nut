class baseCargoset
{
    OnlyPax = false;

    constructor()
    {
        currCargoset.OnlyPax <- GSController.GetSetting("Cargo_Selector")==1;
        trace(4,"OnlyPAX "+ (baseCargoset.OnlyPax ? " yes" : " no") );
    }
}