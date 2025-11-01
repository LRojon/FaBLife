import React from 'react';
import { X } from 'lucide-react';

const FormatSelectionModal = ({ onClose, onSelectFormat }) => {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 z-50 flex items-center justify-center p-4">
      <div className="bg-gray-800 rounded-lg w-80 h-96 p-6 border-2 border-gray-600 transform -rotate-90">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-bold">Format</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-white">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="space-y-4">
          <button
            onClick={() => onSelectFormat('adult')}
            className="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white py-5 rounded-lg font-bold text-lg transition-all transform hover:scale-105"
          >
            Adulte
            <div className="text-sm opacity-80 mt-1">40 PV</div>
          </button>

          <button
            onClick={() => onSelectFormat('young')}
            className="w-full bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white py-5 rounded-lg font-bold text-lg transition-all transform hover:scale-105"
          >
            Jeune
            <div className="text-sm opacity-80 mt-1">20 PV</div>
          </button>
        </div>
      </div>
    </div>
  );
};

export default FormatSelectionModal;