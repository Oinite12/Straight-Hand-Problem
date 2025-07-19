# The Straight-Hand Problem
This is a prototype for straight hand calculation with support for cards counting as multiple ranks. This premise makes more sense in the context of Balatro, specifically [Steamodded](https://github.com/Steamodded/smods). It is intended to be a solution to a problem brought up in [this issue](https://github.com/Steamodded/smods/issues/449), though this prototype is independent of Steamodded or Balatro (i.e. it's largely abstract at the moment).

Sorry for the mess; I'll clean up this code after I sleep.

## Algorithm
First, a card can assume a rank, which can count as multiple technical ranks, dubbed "virtual ranks" (v-ranks). For example, an Ace counts as the v-ranks "ace_low" and "ace_high", referring to the aces in 5-4-3-2-A and A-K-Q-J-10 respectively. These v-ranks are placed in a hierarchy, which specifies the order of v-ranks.

Then given *straightSize* = 5, a proto-straight is defined as a collection of cards that satisfies the following conditions:
* At least *straightSize* cards are played.
* At least *straightSize* unique ranks are played.
* A chain (on the hierarchy) of v-ranks of at least length *straightSize* are played.

Furthermore, a straight is defined as a collection of cards containing at least one proto-straight. For example, though there is a discontinuity in the hand K-Q-J-10-9-5-4-3-2-A, it counts as a straight since it contains two proto-straights (K-Q-J-10-9) (5-4-3-2-A),

To determine which cards will score in the straight, the following algorithm is used:
1. Collect all played cards - if the number of such cards is less than *straightSize*, then do not calculate straights.
2. Compose a table with keys being v-rank IDs, and values being a list of cards contributing to the "activation" of the v-rank.
3. Split this v-rank table into proto-straights. (Select a v-rank, then add it to a vacant table, then check if its neighbors are also in the v-rank table. If so, add to the same vacant table and check recursively, except if the neighbor is already added to the vacant table.)
4. Per proto-straight, collect activating cards into a list, and their corresponding ranks into a *set*. If the sizes of either one are less than *straightSize*, disregard the proto-straight.
5. Collect all activating cards into a bigger list; this list now contains all scoring cards.

Additionally, the length of the longest path in any of the proto-straights is considered the "length" of the straight (distinct from the *size*, which counts how many cards are involved in scoring). This can be determined using a longest-path algorithm for directed acyclic graphs - such an algorithm is in linear time.

## Acknowledgements
* This prototype is built on [theory compiled together by BakersDozenBagels](https://github.com/Steamodded/smods/issues/449#issuecomment-2870224498), specifically the approach involving a directed acyclic graph to define rank hierarchies.
* The dump function used for debugging purposes is a heavily modified version of an [answer by hookenz on Stack Overflow](https://stackoverflow.com/a/27028488).
* Brief research on directed acyclic graphs was largely done on Wikipedia; specifically, the algorithm for calculating the longest path in a directed acyclic graph is from the page [longest path problem](https://en.wikipedia.org/wiki/Longest_path_problem#Acyclic_graphs), and the topological sorting algorithm is Kahn's algorithm, based on the description on the page [topological sorting](https://en.wikipedia.org/wiki/Topological_sorting#Kahn's_algorithm).
* The object implementation was taken from [Balatro](https://playbalatro.com) (dev. LocalThunk), which was in turn taken from [SNKRX](https://github.com/a327ex/SNKRX).
* [Programming in Lua (first edition)](https://www.lua.org/pil/contents.html) was heavily referenced for working with Lua. Particularly, its implementation of Sets in section [13.1](https://www.lua.org/pil/13.1.html) served as the foundation for object-based sets in this prototype.
* The following Balatro mods are referenced in this prototype, as they were referenced in BakersDozenBagels' theory:
  * [UnStable](https://github.com/kirbio/UnStable)
  * [Showdown](https://github.com/Mistyk1/Showdown)
  * [Strange Pencil](https://github.com/DigitalDetective47/strange-pencil)
  * [Ortalab](https://github.com/Eremel/Ortalab)
  * [Familiar](https://github.com/RattlingSnow353/Familiar)
  * [Maximus](https://github.com/the-Astra/Maximus)
  * [TIWMIG](https://github.com/Oinite12/tiwmig-mod)
  * [Cryptid](https://github.com/SpectralPack/Cryptid)