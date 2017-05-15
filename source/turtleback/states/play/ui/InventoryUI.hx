package turtleback.states.play.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using ext.flixel.FlxObjectExt;

/**
 * A sprite group to show an item image and count.
 */
class InventoryItemSprite extends FlxSpriteGroup
{
	public var itemImage(default, null):FlxSprite;
	public var itemCount(default, null):FlxText;
	
	/**
	 * Creates a InvetoryItemSprite for an item.
	 * @param	x	The x position of the group.
	 * @param	y	The y position of the group.
	 * @param	assetPath	The path to the item asset.
	 */
	public function new(x:Float, y:Float, itemType:String, count:Int)
	{
		super(x, y);
		
		moves = false;
		solid = false;
		
		var assetPath = 'assets/images/pickups/${itemType}_inventory.png';
		itemImage = new FlxSprite(0, 0, assetPath);
		itemImage.moves = false;
		itemImage.solid = false;
		
		itemCount = new FlxText();
		itemCount.text = Std.string(count);
		itemCount.alignment = RIGHT;
		itemCount.alignRight(itemImage);
		itemCount.alignBottom(itemImage);
		
		add(itemImage);
		add(itemCount);
	}
	/**
	 * Sets the displayed count for the corresponding item.
	 * @param	count	The updated item count.
	 */
	public function setCount(count:Int):Void
	{
		itemCount.text = Std.string(count);
		itemCount.alignRight(itemImage);
	}
}

/**
 * A collection of sprites that display the player's inventory.
 */
class InventoryUI extends FlxSpriteGroup
{
	private var m_bg:FlxSprite;
	
	private var m_itemSprites:Map<String, InventoryItemSprite>;
	private var m_itemSpriteGroup:FlxSpriteGroup;
	
	/**
	 * Constructs an empty inventory representation.
	 */
	public function new()
	{
		super();
		scrollFactor.set(0, 0);
		
		// With not items, this should not be visible.
		visible = false;
		// This is not mobile and should not collide with anything.
		moves = false;
		solid = false;
		
		m_bg = new FlxSprite();
		m_bg.makeGraphic(1, 80, FlxColor.GRAY);
		m_bg.moves = false;
		m_bg.solid = false;
		
		m_itemSprites = new Map<String, InventoryItemSprite>();
		m_itemSpriteGroup = new FlxSpriteGroup(10, 10);
		m_itemSpriteGroup.moves = false;
		m_itemSpriteGroup.solid = false;
		
		add(m_bg);
		add(m_itemSpriteGroup);
	}
	/**
	 * Adds a slot for a item type to the inventory.
	 * @param	itemType	A unique identifier for the item type.
	 * @param	assetPath An image to show in the inventory slot for this item.
	 * @param	count	The initial number of items of this type.
	 */
	public function addItemType(itemType:String, count:Int = 0):Void
	{
		if (m_itemSprites.exists(itemType))
		{
			return;
		}
		
		if (m_itemSpriteGroup.length == 0)
		{
			visible = true;
		}
		
		var s = new InventoryItemSprite(0, 0, itemType, count);
		var marginLeft = m_itemSpriteGroup.length == 0 ? 0 : 10;
		s.offsetFromLeft(m_bg, m_itemSpriteGroup.width + marginLeft);
		
		m_itemSpriteGroup.add(s);
		m_itemSprites.set(itemType, s);
		
		m_bg.makeGraphic(Std.int(m_itemSpriteGroup.width) + 20, Std.int(this.height), FlxColor.GRAY);
	}
	/**
	 * Updates the item count for a specific item type.
	 * @param	itemType	The item type to update.
	 * @param	count	The number to set the count to.
	 */
	public function updateItemCount(itemType:String, count:Int):Void
	{
		if (m_itemSprites.exists(itemType))
		{
			m_itemSprites.get(itemType).setCount(count);
		}
	}
}
