package turtleback.states.play.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using ext.flixel.FlxObjectExt;

/**
 * A specification of the needed FlxSprites for each item type.
 */
typedef InventoryItemSprites = {
	image:FlxSprite,
	count:FlxText
}

/**
 * A collection of sprites that display the player's inventory.
 */
class InventoryUI extends FlxGroup
{
	private var m_bg:FlxSprite;
	
	private var m_itemSprites:Map<String, InventoryItemSprites>;
	private var m_itemSpriteGroup:FlxSpriteGroup;
	
	/**
	 * Constructs an empty inventory representation.
	 */
	public function new()
	{
		super();
		
		m_bg = new FlxSprite();
		m_bg.makeGraphic(FlxG.width, 80, FlxColor.GRAY);
		add(m_bg);
		m_bg.scrollFactor.set(0, 0);
		
		m_itemSprites = new Map<String, InventoryItemSprites>();
		m_itemSpriteGroup = new FlxSpriteGroup(10, 0);
		m_itemSpriteGroup.alignTop(m_bg);
		add(m_itemSpriteGroup);
		m_itemSpriteGroup.scrollFactor.set(0, 0);
	}
	/**
	 * Adds a slot for a item type to the inventory.
	 * @param	itemType	A unique identifier for the item type.
	 * @param	assetPath An image to show in the inventory slot for this item.
	 * @param	count	The initial number of items of this type.
	 */
	public function addItemType(itemType:String, assetPath:String, count:Int = 0):Void
	{
		var imageX:Float = m_itemSpriteGroup.width;
		if (m_itemSpriteGroup.members.length > 0)
		{
			imageX += 10;
		}
		
		var imageSprite = new FlxSprite(imageX, 0, assetPath);
		imageSprite.alignCenterY(m_bg);
		
		var countSprite = new FlxText();
		countSprite.text = Std.string(count);
		countSprite.alignment = RIGHT;
		countSprite.alignRight(imageSprite);
		countSprite.alignBottom(imageSprite);
		
		m_itemSpriteGroup.add(imageSprite);
		m_itemSpriteGroup.add(countSprite);
		
		m_itemSprites.set(itemType, { image: imageSprite, count: countSprite });
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
			var sprites = m_itemSprites.get(itemType);
			sprites.count.text = Std.string(count);
			sprites.count.alignRight(sprites.image);
		}
	}
}
