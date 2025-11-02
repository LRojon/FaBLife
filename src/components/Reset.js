import React, { useState } from 'react';

const Reset = ({ onReset, playerName }) => {
  const [showModal, setShowModal] = useState(false);

  const handleReset = () => {
    setShowModal(true);
  };

  const confirmReset = () => {
    onReset();
    setShowModal(false);
  };

  const cancelReset = () => {
    setShowModal(false);
  };

  return (
    <>
      <button
        onClick={handleReset}
        className="absolute top-4 right-4 bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm font-bold z-20"
      >
        RESET
      </button>

      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-gray-800 p-6 rounded-lg border-2 border-gray-600 max-w-sm w-full mx-4">
            <h3 className="text-white text-xl font-bold mb-4 text-center">
              Reset {playerName}
            </h3>
            <p className="text-gray-300 mb-6 text-center">
              Êtes-vous sûr de vouloir remettre les PV à zéro ?
            </p>
            <div className="flex gap-4">
              <button
                onClick={cancelReset}
                className="flex-1 bg-gray-600 hover:bg-gray-700 text-white py-2 px-4 rounded font-bold"
              >
                Annuler
              </button>
              <button
                onClick={confirmReset}
                className="flex-1 bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded font-bold"
              >
                Reset
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Reset;