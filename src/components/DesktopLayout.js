import React from 'react';
import Player from './Player';
import CentralMenu from './CentralMenu';

const DesktopLayout = ({ gameState, onReset, onShowHistory }) => {
  return (
    <div 
      className="h-screen w-full flex flex-col bg-gray-900 text-gray-100 overflow-hidden"
      onContextMenu={(e) => e.preventDefault()}
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none'
      }}
    >
      {/* Menu Central (Top, full width) */}
      <CentralMenu 
        onReset={onReset}
        onShowHistory={onShowHistory}
      />

      {/* Players Container (Bottom, side by side) */}
      <div className="flex flex-1 overflow-hidden">
        {/* Player 1 (Left) */}
        <Player
          isPlayer1={true}
          initialLife={gameState.player1.life}
          maxLife={gameState.player1.maxLife}
          gameId={gameState.gameId}
        />

        {/* Player 2 (Right) */}
        <Player
          isPlayer1={false}
          initialLife={gameState.player2.life}
          maxLife={gameState.player2.maxLife}
          gameId={gameState.gameId}
        />
      </div>
    </div>
  );
};

export default DesktopLayout;
