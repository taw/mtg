require_relative "spec_helper"

describe "txt2cod" do
  let(:binary) { Pathname(__dir__)+"../bin/txt2cod" }
  let(:cod) { XML.parse(`#{binary} <#{deck_path}`) }
  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__)+"data/gruul_aggro.txt" }
    let(:expected) {
      """
      <cockatrice_deck>
        <deckname>Unknown</deckname>
        <comments></comments>
        <zone name='main'>
          <card name='Boros Reckoner' number='4' price='0'/>
          <card name='Brimstone Volley' number='4' price='0'/>
          <card name='Burning-Tree Emissary' number='4' price='0'/>
          <card name='Flinthoof Boar' number='4' price='0'/>
          <card name='Ghor-Clan Rampager' number='3' price='0'/>
          <card name='Hellrider' number='4' price='0'/>
          <card name='Lightning Mauler' number='4' price='0'/>
          <card name='Mountain' number='12' price='0'/>
          <card name='Pillar of Flame' number='1' price='0'/>
          <card name='Rakdos Cackler' number='4' price='0'/>
          <card name='Rootbound Crag' number='4' price='0'/>
          <card name='Searing Spear' number='4' price='0'/>
          <card name='Stomping Ground' number='4' price='0'/>
          <card name='Stromkirk Noble' number='4' price='0'/>
        </zone>
        <zone name='side'>
          <card name='Blasphemous Act' number='2' price='0'/>
          <card name='Grafdigger&apos;s Cage' number='3' price='0'/>
          <card name='Mizzium Mortars' number='1' price='0'/>
          <card name='Skullcrack' number='4' price='0'/>
          <card name='Traitorous Blood' number='2' price='0'/>
          <card name='Volcanic Strength' number='3' price='0'/>
        </zone>
      </cockatrice_deck>
      """
    }
    it do
      expect(cod.remove_pretty_printing!).to eq(XML.parse(expected).remove_pretty_printing!)
    end
  end

  describe "UWR flash" do
    let(:deck_path) { Pathname(__dir__)+"data/uwr_flash.txt" }
    let(:expected) {
      """
      <cockatrice_deck>
        <deckname>Unknown</deckname>
        <comments/>
        <zone name='main'>
          <card name='Augur of Bolas' number='4' price='0'/>
          <card name='Azorius Charm' number='4' price='0'/>
          <card name='Cavern of Souls' number='2' price='0'/>
          <card name='Clifftop Retreat' number='3' price='0'/>
          <card name='Counterflux' number='2' price='0'/>
          <card name='Glacial Fortress' number='4' price='0'/>
          <card name='Hallowed Fountain' number='4' price='0'/>
          <card name='Island' number='1' price='0'/>
          <card name='Moorland Haunt' number='1' price='0'/>
          <card name='Pillar of Flame' number='3' price='0'/>
          <card name='Restoration Angel' number='4' price='0'/>
          <card name='Rewind' number='1' price='0'/>
          <card name='Sacred Foundry' number='2' price='0'/>
          <card name='Snapcaster Mage' number='3' price='0'/>
          <card name='Sphinx&apos;s Revelation' number='3' price='0'/>
          <card name='Steam Vents' number='4' price='0'/>
          <card name='Sulfur Falls' number='4' price='0'/>
          <card name='Supreme Verdict' number='2' price='0'/>
          <card name='Syncopate' number='2' price='0'/>
          <card name='Think Twice' number='2' price='0'/>
          <card name='Thundermaw Hellkite' number='2' price='0'/>
          <card name='Turn // Burn' number='1' price='0'/>
          <card name='Warleader&apos;s Helix' number='2' price='0'/>
        </zone>
        <zone name='side'>
          <card name='AEtherling' number='2' price='0'/>
          <card name='Archangel of Thune' number='3' price='0'/>
          <card name='Celestial Flare' number='1' price='0'/>
          <card name='Counterflux' number='2' price='0'/>
          <card name='Detention Sphere' number='1' price='0'/>
          <card name='Izzet Staticaster' number='2' price='0'/>
          <card name='Rhox Faithmender' number='3' price='0'/>
          <card name='Supreme Verdict' number='1' price='0'/>
        </zone>
      </cockatrice_deck>
      """
    }
    it do
      expect(cod.remove_pretty_printing!).to eq(XML.parse(expected).remove_pretty_printing!)
    end
  end
end
