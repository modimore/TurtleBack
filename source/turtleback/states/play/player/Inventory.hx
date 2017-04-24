package turtleback.states.play.player;

import turtleback.states.play.ui.InventoryUI;

/**
 * The player's inventory.
 *
 * Holds the counts of each type of item the player has.
 * Key responsiblities including tracking and updating the counts,
 * and updating the UI when elements and types are added.
 */
class Inventory
{
	private var m_itemTypeCounts:Map<String, Int>;
	private var r_player:Player;
	private var r_ui:InventoryUI;
	
	/**
	 * Creates an empty inventory.
	 * There are no initial item types, and no UI element is connected.
	 */
	public function new(p:Player)
	{
		r_player = p;
		m_itemTypeCounts = new Map<String, Int>();
		r_ui = null;
	}
	/**
	 * Registers a UI element to update counts on.
	 * @param	ui	An inventory UI to update with the player's items.
	 */
	public function connectUI(ui:InventoryUI):Void
	{
		r_ui = ui;
	}
	/**
	 * Adds an item type to the inventory.
	 * The initial count for this item will be zero.
	 * @param	itemType	The key for the item type to add.
	 * @param	assetPath	The path to an image to represent the item type on the UI.
	 */
	public function addItemType(itemType:String, assetPath:String):Void
	{
		if (!m_itemTypeCounts.exists(itemType))
		{
			m_itemTypeCounts.set(itemType, 0);
			r_ui.addItemType(itemType, assetPath, 0);
		}
	}
	/**
	 * Increases the count for an item type by 1.
	 * @param	itemType	The type to increment the count for.
	 */
	public function addItem(itemType:String):Void
	{
		var count:Int = m_itemTypeCounts.get(itemType) + 1;
		m_itemTypeCounts.set(itemType, count);
		
		r_ui.updateItemCount(itemType, count);
		r_player.goals.checkGoal(itemType, count);
	}
}
